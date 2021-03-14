{ lib, stdenv, fetchurl, gettext, libgpgerror, enableCapabilities ? false, libcap
, buildPackages, fetchpatch
}:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "libgcrypt";
  version = "1.9.1";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${pname}-${version}.tar.bz2";
    sha256 = "1nb50bgzp83q6r5cz4v40y1mcbhpqwqyxlay87xp1lrbkf5pm9n5";
  };

  patches = [
    # fix build on 32bit musl
    (fetchpatch {
      name = "fix_building_with_disable-asm_on_x86.patch";
      url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commitdiff_plain;h=af23ab5c5482d625ff52e60606cf044e2b0106c8";
      sha256 = "1m8apm8wra6fk89ggha4d0bba5absihm38zvb2khklqh9q5hj9jw";
    })
  ];

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = lib.optional stdenv.cc.isClang "fortify";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [ libgpgerror ]
    ++ lib.optional stdenv.isDarwin gettext
    ++ lib.optional enableCapabilities libcap;

  strictDeps = true;

  configureFlags = [ "--with-libgpg-error-prefix=${libgpgerror.dev}" ]
      ++ lib.optional (stdenv.hostPlatform.isMusl || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) "--disable-asm"; # for darwin see https://dev.gnupg.org/T5157

  # Necessary to generate correct assembly when compiling for aarch32 on
  # aarch64
  configurePlatforms = [ "host" "build" ];

  postConfigure = ''
    sed -i configure \
        -e 's/NOEXECSTACK_FLAGS=$/NOEXECSTACK_FLAGS="-Wa,--noexecstack"/'
  '';

  # Make sure libraries are correct for .pc and .la files
  # Also make sure includes are fixed for callers who don't use libgpgcrypt-config
  postFixup = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' "$dev/include/gcrypt.h"
  '' + lib.optionalString enableCapabilities ''
    sed -i 's,\(-lcap\),-L${libcap.lib}/lib \1,' $out/lib/libgcrypt.la
  '';

  # TODO: figure out why this is even necessary and why the missing dylib only crashes
  # random instead of every test
  preCheck = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    cp src/.libs/libgcrypt.20.dylib $out/lib
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libgcrypt/";
    description = "General-purpose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
    repositories.git = "git://git.gnupg.org/libgcrypt.git";
  };
}
