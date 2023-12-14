{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gitlike-commands";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "gitlike-commands";
    rev = "refs/tags/v${version}";
    hash = "sha256-VjweN4gigzCNvg6TccZx2Xw1p7SusKplxUTZjItTQc0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Module has no real tests
  doCheck = false;

  pythonImportsCheck = [
    "gitlike_commands"
  ];

  meta = with lib; {
    description = "Easy python module for creating git-style subcommand handling";
    homepage = "https://github.com/unixorn/gitlike-commands";
    changelog = "https://github.com/unixorn/gitlike-commands/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
