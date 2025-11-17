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
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pysilero-vad";
    tag = "v${version}";
    hash = "sha256-zxvYvPnL99yIVHrzbRbKmTazzlefOS+s2TAWLweRSYE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    onnxruntime
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysilero_vad" ];

  # aarch64-linux onnxruntime tries to get cpu information from /sys, which isn't available
  # inside the nix build sandbox.
  doCheck = stdenv.buildPlatform.system != "aarch64-linux";
  dontUsePythonImportsCheck = stdenv.buildPlatform.system == "aarch64-linux";

  meta = with lib; {
    description = "Pre-packaged voice activity detector using silero-vad";
    homepage = "https://github.com/rhasspy/pysilero-vad";
    changelog = "https://github.com/rhasspy/pysilero-vad/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
