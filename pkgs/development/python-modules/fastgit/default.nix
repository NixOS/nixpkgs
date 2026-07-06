{
  lib,
  buildPythonPackage,
  fastcore,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastgit";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastgit";
    tag = finalAttrs.version;
    hash = "sha256-rECQZAhtD6MsDwoED7K8I3HtYdbR8DqCZqP2AqNHroY=";
  };

  build-system = [ setuptools ];

  dependencies = [ fastcore ];

  pythonImportsCheck = [ "fastgit" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module to use git";
    homepage = "https://github.com/AnswerDotAI/fastgit";
    changelog = "https://github.com/AnswerDotAI/fastgit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
