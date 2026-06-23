{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipcl";
  version = "7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pipcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z7tDWRxEsA0CREP2bjeNYkoS9pgpHL0Cr3wcCyMPIeg=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pipcl"
  ];

  meta = {
    description = "Python packaging operations for use by a `setup.py";
    homepage = "https://github.com/ArtifexSoftware/pipcl";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
