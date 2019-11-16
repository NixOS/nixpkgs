{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-5.2.0";

  src = fetchurl {
    url = https://download.osgeo.org/proj/proj-5.2.0.tar.gz;
    sha256 = "0q3ydh2j8qhwlxmnac72pg69rw2znbi5b6k5wama8qmwzycr94gg";
  };

  doCheck = stdenv.is64bit;

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = https://proj4.org;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
