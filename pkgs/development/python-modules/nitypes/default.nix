{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hightime,
  numpy,
  poetry-core,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-doctestplus,
  pytest-mock,
  pytestCheckHook,
  tomlkit,
  tzlocal,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nitypes";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nitypes-python";
    tag = finalAttrs.version;
    hash = "sha256-gUHu5Bp9qJGX3gTRVmE5J/86zpcSrlypKBkan9LZY2s=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    hightime
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-doctestplus
    pytest-mock
    pytest-benchmark
    tomlkit
    tzlocal
  ];

  pythonImportsCheck = [ "nitypes" ];

  meta = {
    changelog = "https://github.com/ni/nitypes-python/releases/tag/${finalAttrs.version}";
    description = "Data types for NI Python APIs";
    homepage = "https://github.com/ni/nitypes-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zehuajun ];
  };
})
