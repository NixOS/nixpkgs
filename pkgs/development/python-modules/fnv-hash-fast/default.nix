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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "fnv-hash-fast";
    tag = "v${version}";
    hash = "sha256-QkLCqIwzJebG3EOylbtB3jFG3bpA5KBUB9arM3Cpros=";
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

  meta = with lib; {
    description = "Fast version of fnv1a";
    homepage = "https://github.com/bdraco/fnv-hash-fast";
    changelog = "https://github.com/bdraco/fnv-hash-fast/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
