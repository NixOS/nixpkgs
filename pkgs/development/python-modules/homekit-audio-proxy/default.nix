{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  sybil,
}:

buildPythonPackage (finalAttrs: {
  pname = "homekit-audio-proxy";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "homekit-audio-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9vC6atYdHvJ/Pkq8n4Amh557GRWLvPofhgnfQJPSBx0=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
    sybil
  ];

  pythonImportsCheck = [ "homekit_audio_proxy" ];

  meta = {
    description = "SRTP audio proxy for HomeKit camera streaming";
    homepage = "https://github.com/bdraco/homekit-audio-proxy";
    changelog = "https://github.com/bdraco/homekit-audio-proxy/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
