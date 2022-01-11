{ lib
, buildPythonPackage
, pythonOlder
, flake8
, pytestCheckHook
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flake8-length";
  version = "0.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3536fee1d2a19c01f56ebb909c4d81f686f8181091a9bc3ddf3a5621c464760a";
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
