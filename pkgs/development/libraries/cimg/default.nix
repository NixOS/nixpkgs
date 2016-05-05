{ stdenv, fetchurl
, unzip }:

stdenv.mkDerivation rec {

  name = "cimg-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "http://cimg.eu/files/CImg_${version}.zip";
    sha256 = "06j3n7gvgxzvprqwf56nnca195y38dcbdlszrxyn5p9w9al437zj";
  };

  buildInputs = [ unzip ];

  builder = ./builder.sh;

  outputs = [ "out" "doc" ];

  meta = with stdenv.lib; {
    description = "A small, open source, C++ toolkit for image processing";
    homepage = http://cimg.eu/;
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
