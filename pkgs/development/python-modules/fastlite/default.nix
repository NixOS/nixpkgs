{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,

  fastcore,
  apswutils,
}:

buildPythonPackage rec {
  pname = "fastlite";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastlite";
    rev = version;
    hash = "sha256-ByP1KuM89WE5te5FAr78Gevq2gjjotQ21B23/xVbdMo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    apswutils
  ];

  pythonImportsCheck = [
    "fastlite"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A bit of extra usability for sqlite";
    homepage = "https://github.com/AnswerDotAI/fastlite";
    changelog = "https://github.com/AnswerDotAI/fastlite/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ x123 ];
  };
}
