{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "websploit";
  version = "4.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "f4rih";
    repo = "websploit";
    tag = version;
    hash = "sha256-LpDfJmH2FbL37Fk86CAC/bxFqM035DBN6c6FPfGpaIw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    scapy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "websploit"
  ];

  meta = {
    description = "High level MITM framework";
    homepage = "https://github.com/f4rih/websploit";
    changelog = "https://github.com/f4rih/websploit/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
    mainProgram = "websploit";
  };
}
