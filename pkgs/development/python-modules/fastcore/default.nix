{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcore";
  version = "1.12.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = finalAttrs.version;
    hash = "sha256-kWF3xEou6yq1si0pfJEljzFKY1xV2IMGQceTOEOe3qI=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    changelog = "https://github.com/fastai/fastcore/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
