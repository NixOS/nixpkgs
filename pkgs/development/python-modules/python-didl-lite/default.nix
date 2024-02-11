{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, defusedxml
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.4.0";
  pyroject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "python-didl-lite";
    rev = "refs/tags/${version}";
    hash = "sha256-A+G97T/udyL/yRqykq1sEGDEI6ZwtDBc5xUNFiJp0UQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    defusedxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "didl_lite"
  ];

  meta = with lib; {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    changelog = "https://github.com/StevenLooman/python-didl-lite/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
