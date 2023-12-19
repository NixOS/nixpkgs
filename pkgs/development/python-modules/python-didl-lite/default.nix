{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, defusedxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.4.0";
  format = "setuptools";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    hash = "sha256-A+G97T/udyL/yRqykq1sEGDEI6ZwtDBc5xUNFiJp0UQ=";
  };

  propagatedBuildInputs = [
    defusedxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "didl_lite" ];

  meta = with lib; {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
