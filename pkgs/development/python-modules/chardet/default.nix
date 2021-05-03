{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DW9ToV20Eg8rCMlPEefZPSyRHuEYtrMKBOw+6DEBefo=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = with lib; {
    description = "Universal encoding detector";
    homepage = "https://github.com/chardet/chardet";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
