{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcore";
  version = "2.2.33";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastcore";
    tag = finalAttrs.version;
    hash = "sha256-hRKCMF22dlNYQBKAHKXt+J4lTRS5v966CoKxgBUWfSc=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = {
    description = "Python module for Fast AI";
    homepage = "https://github.com/AnswerDotAI/fastcore";
    changelog = "https://github.com/AnswerDotAI/fastcore/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
