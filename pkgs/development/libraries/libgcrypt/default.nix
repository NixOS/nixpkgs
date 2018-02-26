{ stdenv, fetchurl, gettext, libgpgerror, enableCapabilities ? false, libcap
, buildPackages
}:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgcrypt-${version}";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "01sca9m8hm6b5v8hmqsfdjhyz013869p1f0fxw9ln52qfnp4q1n8";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = stdenv.lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = stdenv.lib.optional stdenv.isCross buildPackages.stdenv.cc;

  buildInputs = [ libgpgerror ]
    ++ stdenv.lib.optional stdenv.isDarwin gettext
    ++ stdenv.lib.optional enableCapabilities libcap;

  preConfigure = if stdenv.isCross then ''
    # This is intentional: gpg-error-config is a shell script that will work during the build
    mkdir -p "$NIX_BUILD_TOP"/bin
    ln -s ${libgpgerror.dev}/bin/gpg-error-config "$NIX_BUILD_TOP/bin"
    export PATH="$NIX_BUILD_TOP/bin:$PATH"
  '' else null;

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  '' + stdenv.lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    cp src/.libs/libgcrypt.20.dylib $out/lib
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libgcrypt/;
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.wkennington maintainers.vrthra ];
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
