{ stdenv, fetchurl
, unzip }:

stdenv.mkDerivation rec {

  name = "cimg-${version}";
  version = "1.5.9";

  src = fetchurl {
    url = "mirror://sourceforge/project/cimg/CImg-${version}.zip";
    sha256 = "1xn20643gcbl76kvy9ajhwbyjjb73mg65q32ma8mdkwn1qhn7f7c";
  };

  buildInputs = with stdenv.lib;
  [ unzip ];

  builder = ./builder.sh;
  
  meta = with stdenv.lib; {
    description = "A small, open source, C++ toolkit for image processing";
    homepage = http://cimg.sourceforge.net/;
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
