{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  propcache,
}:

buildPythonPackage (finalAttrs: {
  pname = "cached-ipaddress";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "cached-ipaddress";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+A1kMD1L2K+dAWrZJ96qJpx0udRGMWbWApyWtMrE7lk=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ propcache ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cached_ipaddress" ];

  meta = {
    description = "Cache construction of ipaddress objects";
    homepage = "https://github.com/bdraco/cached-ipaddress";
    changelog = "https://github.com/bdraco/cached-ipaddress/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
