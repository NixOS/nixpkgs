{ stdenv, fetchurl
, unzip }:

stdenv.mkDerivation rec {

  name = "cimg-${version}";
  version = "1.7.9";

  src = fetchurl {
    url = "http://cimg.eu/files/CImg_${version}.zip";
    sha256 = "07g81jn25y2wksg9ycf9a7f5bfpcdl3xbrkp1xy3czl043a00y7s";
  };

  nativeBuildInputs = [ unzip ];

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
