{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-4.9.1";

  src = fetchurl {
    url = http://download.osgeo.org/proj/proj-4.9.1.tar.gz;
    sha256 = "06f36s7yi6yky92g235kj9wkcckm04qgzxnj0fla3icb7y7ki87w";
  };

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = http://trac.osgeo.org/proj/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
