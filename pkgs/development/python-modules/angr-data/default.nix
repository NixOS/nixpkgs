{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "angr-data";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xnU3XWvYsQGaCFy2GEwkJvsVbZcg7pHqDXUEIftDRNg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "angr_data" ];

  meta = {
    description = "Function and type prototype data used by angr";
    homepage = "https://github.com/angr/angr-data";
    changelog = "https://github.com/angr/angr-data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
