{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  arrow,
  pytz,
  requests,

  # tests
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "canvasapi";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ucfopen";
    repo = "canvasapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o89rt5Bwz71io1hYwTslm3Q1LMaB8trcfntNcXftF8Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    arrow
    pytz
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "canvasapi" ];

  meta = {
    description = "Python API wrapper for Instructure's Canvas LMS";
    homepage = "https://github.com/ucfopen/canvasapi";
    changelog = "https://github.com/ucfopen/canvasapi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ TMLoew ];
  };
})
