{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  av,
  click,
  numpy,
  pytestCheckHook,
  opencv-python,
  platformdirs,
  tqdm,
  versionCheckHook,
}:
let
  testsResources = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    rev = "a1f226e2f4ec2f8cabb8aa4ac74d5c9d238dec6b";
    hash = "sha256-7Xp2RsFhswumRzWy+oQPj//u16cygUw5V1Lg5Gs9NZI=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "scenedetect";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    tag = "v${finalAttrs.version}-release";
    hash = "sha256-LvxnbPBWoHGrIWjRVR4aqxCKXeVe17xIbkhAagNa7J4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    av
    click
    numpy
    opencv-python
    platformdirs
    tqdm
  ];

  pythonImportsCheck = [ "scenedetect" ];

  preCheck = ''
    cp -r ${testsResources}/tests/resources tests/
    chmod -R +w tests/resources
  '';

  disabledTests = [
    # Requires the optional MoviePy backend, which is not packaged here.
    "test_cli_moviepy_accepts_frame_rate_override"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Python and OpenCV-based scene cut/transition detection program & library";
    homepage = "https://www.scenedetect.com";
    changelog = "https://github.com/Breakthrough/PySceneDetect/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "scenedetect";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
})
