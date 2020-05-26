{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.3.2";
  pname = "pyvoro";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f31c047f6e4fc5f66eb0ab43afd046ba82ce247e18071141791364c4998716fc";
  };

  # No tests in package
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/joe-jordan/pyvoro";
    description = "2D and 3D Voronoi tessellations: a python entry point for the voro++ library";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
