{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R+DauHpRbAuZks1bDJCDSOTH2WQwTRBrIn+tKK4DIZ4=";
  };

  propagatedBuildInputs = [
    six
  ];

  # darwin seems to hang
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    cd examples
    ${python.interpreter} -m ppft.tests
  '';

  pythonImportsCheck = [
    "ppft"
  ];

  meta = with lib; {
    description = "Distributed and parallel Python";
    homepage = "https://ppft.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
