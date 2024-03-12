{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, rns
, setuptools
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
    hash = "sha256-sEim7bCLLkHo6A1onbDQruyNigVKtim5DDAQI8CYUVo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    rns
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "LXMF"
  ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
