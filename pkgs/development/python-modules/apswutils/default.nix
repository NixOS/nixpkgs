{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,

  fastcore,
  apsw,
}:

buildPythonPackage rec {
  pname = "apswutils";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "apswutils";
    rev = version;
    hash = "sha256-zJTUUIKK4B+RsMwl7odlLMBcRUGdeEa/ruu57S080+w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    apsw
  ];

  pythonImportsCheck = [
    "apswutils"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A fork of sqlite-minutils for apsw";
    homepage = "https://github.com/AnswerDotAI/apswutils";
    changelog = "https://github.com/AnswerDotAI/apswutils/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
  };
}
