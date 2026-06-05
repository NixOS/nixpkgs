{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apsw,
  fastcore,

  # tests
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "apswutils";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "apswutils";
    tag = finalAttrs.version;
    hash = "sha256-lqtgjQ4nhmcf52mFeXdFxvd8WNsDDR9PEeWAncBX46g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    apsw
    fastcore
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "apswutils"
  ];

  meta = {
    description = "A fork of sqlite-minutils for apsw";
    homepage = "https://github.com/AnswerDotAI/apswutils";
    changelog = "https://github.com/AnswerDotAI/apswutils/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
