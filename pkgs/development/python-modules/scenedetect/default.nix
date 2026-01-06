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
buildPythonPackage rec {
  pname = "scenedetect";
  # note that nix-update will add "-release" (as in the github tag) at the end of the version, which will break the update
  # and versionCheckHook fails if version is including "-release"
  version = "0.6.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    tag = "v${version}-release";
    hash = "sha256-bLR04wn4O23fHC12ZvWwDI7gLGvMhm+YnBOy4zYMPSM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    av
    click
    numpy
    opencv-python
    platformdirs
    tqdm
  ];

  pythonRelaxDeps = [
    "click"
  ];

  pythonImportsCheck = [
    "scenedetect"
  ];

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
    changelog = "https://github.com/Breakthrough/PySceneDetect/releases/tag/v${version}-release";
    mainProgram = "scenedetect";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
}
