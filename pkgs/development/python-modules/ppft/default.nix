{ lib, stdenv
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R+DauHpRbAuZks1bDJCDSOTH2WQwTRBrIn+tKK4DIZ4=";
  };

  propagatedBuildInputs = [ six ];

  # darwin seems to hang
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    cd examples
    ${python.interpreter} -m ppft.tests
  '';

  meta = with lib; {
    description = "Distributed and parallel python";
    homepage = "https://github.com/uqfoundation";
    license = licenses.bsd3;
  };

}
