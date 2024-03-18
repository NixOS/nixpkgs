{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "lnkparse3";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Matmaus";
    repo = "LnkParse3";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ej2Tv1RViHqm2z1EG/cAkImcvtJcwSc3I0DxIL/q8FI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "LnkParse3"
  ];

  meta = with lib; {
    description = "Windows Shortcut file (LNK) parser";
    homepage = "https://github.com/Matmaus/LnkParse3";
    changelog = "https://github.com/Matmaus/LnkParse3/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
