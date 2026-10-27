{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  hatchling,
  # dependencies
  filelock,
  numpy,
  onnxruntime,
}:
buildPythonPackage (finalAttrs: {
  pname = "minisbd";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "MiniSBD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qoST0w4XEbz67dHIe/qaTAm14SDY1Z9ldAHvNLqjzrU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    filelock
    numpy
    onnxruntime
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  pythonImportsCheck = lib.optionals (
    !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)
  ) [ "minisbd" ];

  meta = {
    description = "Free and open source library for fast sentence boundary detection";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "https://github.com/LibreTranslate/MiniSBD/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Stebalien ];
  };
})
