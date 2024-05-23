{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  pythonRelaxDepsHook,

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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pysilero-vad";
    rev = "fc1e3f74e6282249c1fd67ab0f65832ad1ce9cc5";
    hash = "sha256-5jS2xZEtvzXO/ffZzseTTUHfE528W9FvKB0AKG6T62k=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "numpy" ];

  propagatedBuildInputs = [
    numpy
    onnxruntime
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysilero_vad" ];

  meta = with lib; {
    # what():  /build/source/include/onnxruntime/core/common/logging/logging.h:294 static const onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger() Attempt to use DefaultLogger but none has been registered.
    broken = stdenv.isAarch64 && stdenv.isLinux;
    description = "Pre-packaged voice activity detector using silero-vad";
    homepage = "https://github.com/rhasspy/pysilero-vad";
    changelog = "https://github.com/rhasspy/pysilero-vad/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
