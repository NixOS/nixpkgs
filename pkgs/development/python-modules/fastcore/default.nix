{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcore";
  version = "1.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = finalAttrs.version;
    hash = "sha256-6nEHriXEQjovcDY9jh/QkwiQc2Wdq/87Nxfa+AhrPj4=";
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
