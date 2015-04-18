{ fetchurl, stdenv, flex, bison, freetype, zlib, libpng
, perl }:

stdenv.mkDerivation rec {
  name = "ming-0.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/ming/${name}.tar.bz2";
    sha256 = "1sws4cs9i9hysr1l0b8hsmqf4gh06ldc24fw6avzr9y3vydhinl2";
  };

  # We don't currently build the Python, Perl, PHP, etc. bindings.
  # Perl is needed for the test suite, though.

  buildInputs = [ flex bison freetype zlib libpng perl ];

  doCheck = true;

  meta = {
    description = "Library for generating Flash `.swf' files";

    longDescription = ''
      Ming is a library for generating Macromedia Flash files (.swf),
      written in C, and includes useful utilities for working with
      .swf files.  It has wrappers that allow it to be used in C++,
      PHP, Python, Ruby, and Perl.
    '';

    homepage = http://www.libming.org/;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
