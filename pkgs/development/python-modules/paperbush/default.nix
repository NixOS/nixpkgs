{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "paperbush";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "paperbush";
    rev = "refs/tags/${version}";
    hash = "sha256-wJV+2aGK9eSw2iToiHh0I7vYAuND2pRYGhnf7CB1a+0=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "paperbush" ];

  meta = {
    changelog = "https://github.com/trag1c/paperbush/blob/${src.rev}/CHANGELOG.md";
    description = "Super concise argument parsing tool for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
