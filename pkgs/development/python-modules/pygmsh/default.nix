{ lib, buildPythonPackage, fetchPypi, gmsh, meshio, numpy, importlib-metadata }:

buildPythonPackage rec {
  pname = "pygmsh";
  version = "6.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xl88xbs7p3lp2paqqnrn4fxijxd3agwqac33f66bxdp2drklzn0";
  };

  propagatedBuildInputs = [ importlib-metadata meshio numpy gmsh ];

  meta = with lib; {
    description = "Python frontend for Gmsh";
    homepage = "https://github.com/nschloe/pygmsh";
    license = licenses.mit;
    maintainers = [ maintainers.wulfsta ];
  };
}
