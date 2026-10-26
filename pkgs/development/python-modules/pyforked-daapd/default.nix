{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyforked-daapd";
  version = "0.1.14";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-v1NOlwP8KtBsQiqwbx1y8p8lABEuEJdNhvR2kGzLxKs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyforked_daapd"
  ];

  # Tests require a running forked-daapd server
  doCheck = false;

  meta = {
    description = "Python interface for forked-daapd";
    homepage = "https://github.com/uvjustin/pyforked-daapd";
    changelog = "https://github.com/uvjustin/pyforked-daapd/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
