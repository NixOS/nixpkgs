{
  lib,
  autoPatchelfHook,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyopen-wakeword";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyopen-wakeword";
    tag = "v${version}";
    hash = "sha256-LJ0pHP4nsTx3GPuWUwOwNuXR9tUKABqSHnLSvMlfm1Y=";
  };

  postPatch = ''
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
    description = "Alternative Python library for openWakeWord";
    homepage = "https://github.com/rhasspy/pyopen-wakeword";
    changelog = "https://github.com/rhasspy/pyopen-wakeword/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    # vendors prebuilt libtensorflowlite_c.{so,dll,dylib}
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
