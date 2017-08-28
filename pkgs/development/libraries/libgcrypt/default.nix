{ stdenv, fetchurl, fetchpatch, libgpgerror, enableCapabilities ? false, libcap }:

assert enableCapabilities -> stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libgcrypt-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "06w97l88y2c29zf8p8cg0m4k2kiiyj6pqxdl0cxigi3wp2brdr13";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev";

  # The CPU Jitter random number generator must not be compiled with
  # optimizations and the optimize -O0 pragma only works for gcc.
  # The build enables -O2 by default for everything else.
  hardeningDisable = stdenv.lib.optional stdenv.cc.isClang "fortify";

  buildInputs = [ libgpgerror ]
    ++ stdenv.lib.optional enableCapabilities libcap;

  # Shouldn't be needed after 1.8.1
  patches = if stdenv.isArm && stdenv.system != "armv7l-linux"
    then fetchpatch {
        url = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=patch;h=4a7aa30ae9f3ce798dd886c2f2d4164c43027748";
        name = "arm.patch";
        sha256 = "1dq9s0xwpbg7s5sghvssmwh4v88x733zm6c8ab3flllq8h7c8fq5";
      }
    else null;

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
    description = "General-pupose cryptographic library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.wkennington maintainers.vrthra ];
    repositories.git = git://git.gnupg.org/libgcrypt.git;
  };
}
