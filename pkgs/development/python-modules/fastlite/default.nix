{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  fastcore,
  apswutils,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastlite";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastlite";
    tag = finalAttrs.version;
    hash = "sha256-q2eGP/GRWqgbvWOVuLch33VkYbedeDRsxsnN+xsevPI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    apswutils
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "fastlite"
  ];

  meta = {
    description = "A bit of extra usability for sqlite";
    homepage = "https://github.com/AnswerDotAI/fastlite";
    changelog = "https://github.com/AnswerDotAI/fastlite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
