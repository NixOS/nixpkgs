{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "busypie";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rockem";
    repo = "busypie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MIwME5QM0BDpYP9frraJP/1v0lTZpPzgbqAawpGAcU0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "busypie" ];

  meta = {
    description = "Expressive busy wait for Python";
    homepage = "https://github.com/rockem/busypie";
    changelog = "https://github.com/rockem/busypie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
