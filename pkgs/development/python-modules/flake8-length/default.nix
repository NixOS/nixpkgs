{ lib
, buildPythonPackage
, pythonOlder
, flake8
, pytestCheckHook
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flake8-length";
  version = "0.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e3c068005b0b3b5c8345923fe3e9a107c980baa1354dd19d820018f87409427";
  };

  propagatedBuildInputs = [
    flake8
  ];

  pythonImportsCheck = [
    "flake8_length"
  ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/" ];

  meta = {
    description = "Flake8 plugin for a smart line length validation";
    homepage = "https://github.com/orsinium-labs/flake8-length";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sauyon ];
  };
}
