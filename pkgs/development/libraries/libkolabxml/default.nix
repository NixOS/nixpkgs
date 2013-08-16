{ stdenv, fetchurl, boost, curl, cmake, xercesc, qt4
#, qt4, clucene_core, librdf_redland, libiodbc
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libkolabxml-0.8.4";

  src = fetchurl {
    url = "http://mirror.kolabsys.com/pub/releases/${name}.tar.gz";
    sha256 = "08gdhimnrhizpbvddj7cyz4jwwxrx5a70vz29cy989qgym2vn72q";
  };

  buildInputs = [ boost curl xercesc ];
#  buildInputs = [ qt4 clucene_core librdf_redland libiodbc ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ phreedo ];
    inherit (qt4.meta) platforms;
  };
}
