{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mergedict";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4ZkrNqVCKQFPvLx6nIwo0fSuEx6h2NNFyTlz+fDcb9w=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mergedict" ];

  meta = {
    description = "Python dict with a merge() method";
    homepage = "https://github.com/schettino72/mergedict";
    changelog = "https://github.com/schettino72/mergedict/blob/${finalAttrs.version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
