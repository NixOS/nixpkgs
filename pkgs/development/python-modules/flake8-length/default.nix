{ lib
, buildPythonPackage
, pythonOlder
, flake8
, pytestCheckHook
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flake8-length";
  version = "0.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15frvccm1qx783jlx8fw811ks9jszln3agbb58lg4dhbmjaf2cxw";
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
