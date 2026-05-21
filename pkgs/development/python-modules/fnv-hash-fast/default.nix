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

buildPythonPackage rec {
  pname = "fnv-hash-fast";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "fnv-hash-fast";
    tag = "v${version}";
    hash = "sha256-wfiOI23LzdoTYl5/Wr/+3qvcJ3ce9ZrfETQXX1g6eIU=";
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
    changelog = "https://github.com/bdraco/fnv-hash-fast/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
