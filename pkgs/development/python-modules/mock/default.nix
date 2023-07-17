{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mock";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Xpaq1czaRxjgointlLICTfdcwtVVdbpXYtMfV2e4dn0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mock"
  ];

  meta = with lib; {
    description = "Mock objects for Python";
    homepage = "https://github.com/testing-cabal/mock";
    license = licenses.bsd2;
  };
}
