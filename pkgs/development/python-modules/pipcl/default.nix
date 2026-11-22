{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipcl";
  version = "12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pipcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/JvfGN2Txie+4+MxL7BO63QCXIT+gHQ4U6nrBRBtByg=";
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
