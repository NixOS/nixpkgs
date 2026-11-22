{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  fastprogress,
  fastcore,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastdownload";
  version = "0.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-euYXbi45feiiV2TUvhswTJu+gV582f82hW98uph0s/c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastprogress
    fastcore
  ];

  pythonImportsCheck = [ "fastdownload" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Easily download, verify, and extract archives";
    homepage = "https://github.com/fastai/fastdownload";
    changelog = "https://github.com/fastai/fastdownload/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
