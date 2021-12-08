{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "chardet";
     repo = "chardet";
     rev = "4.0.0";
     sha256 = "0c9jzwya4mll9hv4zad27d1nnj9p0x8g4ficx3km33v61wrjj4qk";
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
