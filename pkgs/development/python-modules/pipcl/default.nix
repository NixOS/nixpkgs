{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipcl";
  version = "11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pipcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gefz+BUWojruztnb1zEJWqBNU3HzdPjl/pw9lce+R7Y=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pipcl"
  ];

  meta = {
    description = "Python packaging operations for use by setup.py";
    homepage = "https://github.com/ArtifexSoftware/pipcl";
    changelog = "https://github.com/ArtifexSoftware/pipcl/blob/${finalAttrs.src.tag}/README.rst#changelog";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
