{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  cmake,
  ninja,
  scikit-build-core,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysilero-vad";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pysilero-vad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gQDZuu8hN0s+yfkp22w39/Aje5/6qdX0W95FPu6obw0=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

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
    broken = stdenv.hostPlatform.isDarwin; # ld: unknown option: --disable-new-dtags
    description = "Pre-packaged voice activity detector using silero-vad";
    homepage = "https://github.com/rhasspy/pysilero-vad";
    changelog = "https://github.com/rhasspy/pysilero-vad/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
