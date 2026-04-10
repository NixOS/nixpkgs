{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  numpy,
  pandas,
  pytestCheckHook,
  requests,
  responses,
  tqdm,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "cdcs";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UpPoTdcDDCmombeScFgjsFX+//Yfnn+ClDwYsZh0dxI=";
  };

  build-system = [ uv-build ];

  dependencies = [
    ipython
    numpy
    pandas
    requests
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "cdcs" ];

  disabledTests = [
    # Assertion errors
    "test_get_workspaces_v2"
    "test_get_workspaces_v3"
  ];

  meta = {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
    changelog = "https://github.com/usnistgov/pycdcs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
