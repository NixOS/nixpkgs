{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "chardet";
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DW9ToV20Eg8rCMlPEefZPSyRHuEYtrMKBOw+6DEBefo=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/chardet/chardet";
    description = "Universal encoding detector";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
