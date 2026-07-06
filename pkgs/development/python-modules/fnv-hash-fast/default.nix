{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  poetry-core,
  setuptools,
  fnvhash,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fnv-hash-fast";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "fnv-hash-fast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yDEgVNaSqZ1AJivpkpinZznKlPEXH6mjXBe5aVp/3hQ=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ fnvhash ];

  pythonImportsCheck = [ "fnv_hash_fast" ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Fast version of fnv1a";
    homepage = "https://github.com/bdraco/fnv-hash-fast";
    changelog = "https://github.com/Bluetooth-Devices/fnv-hash-fast/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
