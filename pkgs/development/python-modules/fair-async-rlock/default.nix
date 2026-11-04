{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fair-async-rlock";
  version = "1.0.7";
  pyproject = true;

  # Upstream publishes no tags; this is the commit that `setup.py` reports as
  # 1.0.7.
  src = fetchFromGitHub {
    owner = "Joshuaalbert";
    repo = "FairAsyncRLock";
    rev = "7c3ed4e08892638dba262eaf0b1a7b1fad4b2608";
    hash = "sha256-4Iln4WSQUPfiLRbjNx7mruP8mchVZT8fNXtpEJPJNn4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fair_async_rlock" ];

  meta = {
    description = "Fair, reentrant asynchronous read-write lock";
    homepage = "https://github.com/Joshuaalbert/FairAsyncRLock";
    # The classifiers claim Apache-2.0, but the LICENSE file is MIT:
    # https://github.com/Joshuaalbert/FairAsyncRLock/issues/30
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
