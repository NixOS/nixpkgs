{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-4.9.2";

  src = fetchurl {
    url = http://download.osgeo.org/proj/proj-4.9.2.tar.gz;
    sha256 = "15kpcmz3qjxfrs6vq48mgyvb4vxscmwgkzrdcn71a60wxp8rmgv0";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = http://trac.osgeo.org/proj/;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
