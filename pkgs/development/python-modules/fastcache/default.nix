{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastcache";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-beGxbnAzW3veJmcH60AaOq7CIPtmxdE7Aqvw6ri+eCs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "fastcache" ];

  meta = {
    description = "C implementation of Python3 lru_cache";
    homepage = "https://github.com/pbrady/fastcache";
    changelog = "https://github.com/pbrady/fastcache/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.mit;
  };
})
