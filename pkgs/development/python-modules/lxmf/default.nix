{ lib
, buildPythonPackage
, fetchFromGitHub
, rns
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
    hash = "sha256-3kjg0Q7nXMSjBq2suPtIUvUEGCJr6pTo53ZbjMC5uZ0=";
  };

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
