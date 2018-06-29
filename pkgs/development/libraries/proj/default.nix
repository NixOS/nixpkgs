{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-4.9.3";

  src = fetchurl {
    url = https://download.osgeo.org/proj/proj-4.9.3.tar.gz;
    sha256 = "1xw5f427xk9p2nbsj04j6m5zyjlyd66sbvl2bkg8hd1kx8pm9139";
  };

  doCheck = stdenv.is64bit;

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = http://trac.osgeo.org/proj/;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
