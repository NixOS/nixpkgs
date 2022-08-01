{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, six

, pytestCheckHook
, keyring
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "4.1.1";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6HFSuVYvqCK1Ew7jECVRK02m5tsNrzjIcFZtCLhK3tY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
    keyring
  ];

  pythonImportsCheck = [
    "keyrings.alt"
  ];

  meta = with lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    maintainers = with maintainers; [ nyarly ];
  };
}
