{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  importlib-resources,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "acres";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "acres";
    tag = finalAttrs.version;
    hash = "sha256-D2w/xGlt0ApQ1Il9pzHPcL1s3CmCCOdgRpvUw/LI3gA=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    importlib-resources
  ];

  pythonImportsCheck = [
    "acres"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Data-loading utility for Python";
    homepage = "https://github.com/nipreps/acres";
    changelog = "https://github.com/nipreps/acres/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
