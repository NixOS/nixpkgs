{ fetchurl, stdenv, flex, bison, freetype, zlib, libpng
, perl }:

stdenv.mkDerivation rec {
  name = "ming-0.4.0.rc1";

  src = fetchurl {
    url = "mirror://sourceforge/ming/${name}.tar.bz2";
    sha256 = "19brcqh4mqav5gsnmnb6j4gv9s0rmkg71657ck17xj8fdklq38y7";
  };

  # We don't currently build the Python, Perl, PHP, etc. bindings.
  # Perl is needed for the test suite, though.

  buildInputs = [ flex bison freetype zlib libpng perl ];

  doCheck = true;

  meta = {
    description = "Ming, a library for generating Flash `.swf' files";

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
