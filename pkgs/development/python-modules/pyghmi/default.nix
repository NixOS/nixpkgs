{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
  python-dateutil,
  pbr,
  coverage,
  oslotest,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyghmi";
  version = "1.6.19";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MKCy4UWj5DKcjYaUhjXu47NHnsan7LxMw1B+bfP+WcI=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    python-dateutil
  ];

  nativeCheckInputs = [
    coverage
    oslotest
    stestrCheckHook
  ];

  pythonImportsCheck = [ "pyghmi" ];

  meta = {
    description = "Pure Python (mostly IPMI) server management library";
    homepage = "https://opendev.org/x/pyghmi/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codgician ];
  };
})
