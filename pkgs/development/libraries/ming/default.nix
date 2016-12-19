{ stdenv, fetchFromGitHub
, autoreconfHook, flex, bison, perl
, zlib, freetype, libpng, giflib
}:

stdenv.mkDerivation rec {
  pname = "ming";
  version = "0.4.7";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "libming";
    owner = "libming";
    rev = "${pname}-${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "17ngz1n1mnknixzchywkhbw9s3scad8ajmk97gx14xbsw1603gd2";
  };

  # We don't currently build the Python, Perl, PHP, etc. bindings.
  # Perl is needed for the test suite, though.

  outputs = [ "bin" "dev" "out" ];
  nativeBuildInputs = [ autoreconfHook flex bison perl ];
  buildInputs = [ freetype zlib libpng giflib ];

  postFixup = ''moveToOutput "bin/ming-config" $dev'';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library for generating Flash `.swf' files";

    longDescription = ''
      Ming is a library for generating Macromedia Flash files (.swf),
      written in C, and includes useful utilities for working with
      .swf files.  It has wrappers that allow it to be used in C++,
      PHP, Python, Ruby, and Perl.
    '';

    homepage = http://www.libming.org/;

    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
