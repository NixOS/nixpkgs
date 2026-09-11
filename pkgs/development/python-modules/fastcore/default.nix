{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcore";
  version = "2.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = finalAttrs.version;
    hash = "sha256-MWQl2O5NqxVzWcCU9dewUdh6iT8zFSMDZey/YogJBik=";
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
