{ stdenv, fetchurl, boost, zlib, bzip2 }:

let
  name    = "xylib";
  version = "1.3";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "https://github.com/wojdyr/xylib/releases/download/v${version}/${name}-${version}.tar.bz2";
    sha256 = "09j426qjbg3damch1hfw16j992kn2hj8gs4lpvqgfqdw61kvqivh";
  };

  buildInputs = [boost zlib bzip2 ];

  meta = {
    description = "xylib is a portable library for reading files that contain x-y data from powder diffraction, spectroscopy and other experimental methods.";
    license = "LGPL";
    homepage = http://xylib.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
