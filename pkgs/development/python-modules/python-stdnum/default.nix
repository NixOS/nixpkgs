{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-stdnum";
  version = "1.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N04rXhORLM2/ULCyP8osPgUxF0gFwy104UXzd1Yyg0A=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "stdnum"
  ];

  meta = with lib; {
    description = "Python module to handle standardized numbers and codes";
    homepage = "https://arthurdejong.org/python-stdnum/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ johbo ];
  };
}
