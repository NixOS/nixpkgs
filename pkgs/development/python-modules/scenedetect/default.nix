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
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    tag = "v${version}-release";
    hash = "sha256-G5NLk6eOpclfrzzHad2KT3uZqydSJU0oF/4L2NIdZe0=";
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
