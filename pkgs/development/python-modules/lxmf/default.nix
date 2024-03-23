{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, rns
, setuptools
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    rev = "refs/tags/${version}";
    hash = "sha256-JDD1X0/5xuqGN/Qw67tTFqfoWUd7Ah80/mimK01tG6Y=";
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
    mainProgram = "lxmd";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
