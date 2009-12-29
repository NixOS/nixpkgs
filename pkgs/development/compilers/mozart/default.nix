{stdenv, fetchurl, flex, bison, perl, gmp, zlib, tcl, tk, gdbm, m4, x11, emacs}:

stdenv.mkDerivation {
  name = "mozart-1.4.0";
  src = fetchurl {
    url = http://www.mozart-oz.org/download/mozart-ftp/store/1.4.0-2008-07-02-tar/mozart-1.4.0.20080704-src.tar.gz;
    sha256 = "5da73d80b5aa7fa42edca64159a1a076323f090e5c548f3747f94d0afc60b223";
  };

  buildInputs = [flex bison perl gmp zlib tcl tk gdbm m4 x11 emacs];

  # micq gives a compile error for me
  configureFlags = "--with-tcl=${tcl}/lib --with-tk=${tk}/lib --disable-contrib-micq";
}
