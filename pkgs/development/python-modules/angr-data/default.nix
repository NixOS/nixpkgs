{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "angr-data";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xnU3XWvYsQGaCFy2GEwkJvsVbZcg7pHqDXUEIftDRNg=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Function and type prototype definitions for angr";
    homepage = "https://github.com/angr/angr-data";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ letgamer ];
  };
})
