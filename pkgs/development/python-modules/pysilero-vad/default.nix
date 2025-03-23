{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  numpy,
  onnxruntime,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysilero-vad";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pysilero-vad";
    tag = "v${version}";
    hash = "sha256-v6Ok0JWhdp0oM6I87BVojJgMikdomUX/Vk2ZVje0z+w=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    numpy
    onnxruntime
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysilero_vad" ];

  meta = with lib; {
    # what():  /build/source/include/onnxruntime/core/common/logging/logging.h:294 static const onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger() Attempt to use DefaultLogger but none has been registered.
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
    description = "Pre-packaged voice activity detector using silero-vad";
    homepage = "https://github.com/rhasspy/pysilero-vad";
    changelog = "https://github.com/rhasspy/pysilero-vad/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
