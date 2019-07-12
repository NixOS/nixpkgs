{ lib
, buildPythonPackage
, fetchPypi
, meshio
, numpy
}:

buildPythonPackage rec {
  pname = "pygmsh";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fbd1579aa1a9dbe70ae4aec9d2674d36eb2f9bb18b2a4f71d455107c708fcef";
  };

  propagatedBuildInputs = [
    meshio
    numpy
  ];

  meta = with lib; {
    description = "Python frontend for Gmsh";
    homepage = https://github.com/nschloe/pygmsh;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
