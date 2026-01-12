{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysilero-vad";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pysilero-vad";
    tag = "v${version}";
    hash = "sha256-cqjuU5JtsL+Fp3m3uzz8flrJEyn+JDUMWsXU0Ioh87U=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysilero_vad" ];

  # aarch64-linux onnxruntime tries to get cpu information from /sys, which isn't available
  # inside the nix build sandbox.
  #doCheck = stdenv.buildPlatform.system != "aarch64-linux";
  dontUsePythonImportsCheck = stdenv.buildPlatform.system == "aarch64-linux";

  preCheck = ''
    # don't shadow the build result during tests
    rm -rf pysilero_vad
  '';

  meta = {
    description = "Pre-packaged voice activity detector using silero-vad";
    homepage = "https://github.com/rhasspy/pysilero-vad";
    changelog = "https://github.com/rhasspy/pysilero-vad/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
