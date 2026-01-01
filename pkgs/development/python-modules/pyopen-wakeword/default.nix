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
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyopen-wakeword";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-czFDuIZ10aetr6frkKSozPjS7zMeNJ5/WVLA7Ib1CaI=";
=======
    hash = "sha256-LJ0pHP4nsTx3GPuWUwOwNuXR9tUKABqSHnLSvMlfm1Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    # elftools.common.exceptions.ELFError: Magic number does not match
    broken = stdenv.hostPlatform.isDarwin;
    description = "Alternative Python library for openWakeWord";
    homepage = "https://github.com/rhasspy/pyopen-wakeword";
    changelog = "https://github.com/rhasspy/pyopen-wakeword/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    # vendors prebuilt libtensorflowlite_c.{so,dll,dylib}
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
