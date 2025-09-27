{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyforked-daapd";
  version = "0.1.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "Python interface for forked-daapd";
    homepage = "https://github.com/uvjustin/pyforked-daapd";
    changelog = "https://github.com/uvjustin/pyforked-daapd/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = [ ];
  };
}
