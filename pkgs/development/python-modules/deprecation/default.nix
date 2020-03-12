{ lib, buildPythonPackage, fetchPypi, python, packaging, unittest2 }:

buildPythonPackage rec {
  pname = "deprecation";
  version = "2.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vcjy6flqbzgjh4zhcs0sl83b946wxrlsx5miliz0ik1d9kjyff0";
  };

  propagatedBuildInputs = [ packaging ];

  checkInputs = [ unittest2 ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "A library to handle automated deprecations";
    homepage = https://deprecation.readthedocs.io/;
    license = licenses.asl20;
  };
}
