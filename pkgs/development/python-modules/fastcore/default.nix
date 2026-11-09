{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcore";
  version = "2.2.39";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastcore";
    tag = finalAttrs.version;
    hash = "sha256-OqLQVZD4WVB4GqYlrGRG5HD4DMXAIvLk/aewP3N3g+A=";
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
