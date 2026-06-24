{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipcl";
  version = "9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "pipcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v4nGQTKUAg+lTE3UAJwQWcTkH5Xi1m0mCSAnVZYt7Gk=";
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
