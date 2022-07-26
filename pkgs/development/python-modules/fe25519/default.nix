{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, nose
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hzdt8932WonJAaQPtL346JFPqxFXkNW4XQvbQlSoJJE=";
  };

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=fe25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "fe25519"
  ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
