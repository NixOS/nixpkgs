{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  aiohttp,
  requests,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "brunt";
  version = "1.2.0";

  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5wRifce5wKUMZ66Q8dMgsU+Z8rL8m/HvBGGxQdzxvOk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  # tests require Brunt hardware
  doCheck = false;

  pythonImportsCheck = [ "brunt" ];

  meta = {
    description = "Unofficial Python SDK for Brunt";
    homepage = "https://github.com/eavanvalkenburg/brunt-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
