{ stdenv, fetchurl, mpfr, m4, binutils, fetchcvs, emacs, zlib, which
, texinfo, libX11, xproto, inputproto, libXi, gmp
, libXext, xextproto, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  name = "gcl-${version}";
  version = "2.6.12";

  src = fetchurl {
    sha256 = "1s4hs2qbjqmn9h88l4xvsifq5c3dlc5s74lyb61rdi5grhdlkf4f";
    url = "http://gnu.spinellicreations.com/gcl/${name}.tar.gz";
  };

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xproto inputproto libXi
    libXext xextproto libXt libXaw libXmu
    zlib which texinfo
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  hardening_pic = false;

  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
