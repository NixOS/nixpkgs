{ lib
, buildPythonPackage
, pythonOlder
, flake8
, pytestCheckHook
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flake8-length";
  version = "0.3.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Dr1hTCU2G1STczXJsUPMGFYs1NpIAk1I95vxXsRTtRA=";
  };

  propagatedBuildInputs = [
    flake8
  ];

  pythonImportsCheck = [
    "flake8_length"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/" ];

  meta = {
    description = "Flake8 plugin for a smart line length validation";
    homepage = "https://github.com/orsinium-labs/flake8-length";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sauyon ];
  };
}
