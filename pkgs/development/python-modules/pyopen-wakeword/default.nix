{
  lib,
  stdenv,
  autoPatchelfHook,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyopen-wakeword";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyopen-wakeword";
    tag = "v${version}";
    hash = "sha256-czFDuIZ10aetr6frkKSozPjS7zMeNJ5/WVLA7Ib1CaI=";
  };

  postPatch = ''
    # install pre-compiled libtensorflowlite
    python ./script/copy_lib
  '';

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyopen_wakeword"
  ];

  meta = {
    broken =
      # elftools.common.exceptions.ELFError: Magic number does not match
      stdenv.hostPlatform.isDarwin
      ||
        # segfaults when calling into libtensorflowlite
        stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
    description = "Alternative Python library for openWakeWord";
    homepage = "https://github.com/rhasspy/pyopen-wakeword";
    changelog = "https://github.com/rhasspy/pyopen-wakeword/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    # vendors prebuilt libtensorflowlite_c.{so,dll,dylib}
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
