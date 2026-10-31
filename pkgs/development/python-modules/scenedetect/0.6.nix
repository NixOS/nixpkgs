# scenedetect 0.7 is a breaking API change. dvr-scan 1.8.2 (the latest release) is
# only compatible with the 0.6 series; upstream migrated to scenedetect 0.7 on the
# unreleased 2.0 branch. This pin keeps dvr-scan building until dvr-scan 2.0 is
# released, at which point this file and the scenedetect_0_6 alias can be removed.
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
    rev = "94389267a344785643980a2e0bb18179dcca01d3";
    hash = "sha256-7ws7F7CkEJAa0PgfMEOwnpF4Xl2BQCn9+qFQb5MMlZ0=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "scenedetect";
  version = "0.6.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    tag = "v${finalAttrs.version}-release";
    hash = "sha256-bLR04wn4O23fHC12ZvWwDI7gLGvMhm+YnBOy4zYMPSM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "click"
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
