{ lib, buildPythonPackage, fetchPypi, exdown, gmsh, meshio, numpy, pytest, importlib-metadata }:

buildPythonPackage rec {
  pname = "pygmsh";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lm2m6y3lwkqna7vrg9mn32nsa3pc27x8m32qlmc3wq1wn216xj0";
  };

  propagatedBuildInputs = [ importlib-metadata exdown meshio numpy gmsh ];

  patches = [
    ./add_empty_setup.patch
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python frontend for Gmsh";
    homepage = "https://github.com/nschloe/pygmsh";
    license = licenses.mit;
    maintainers = [ maintainers.wulfsta ];
  };
}
