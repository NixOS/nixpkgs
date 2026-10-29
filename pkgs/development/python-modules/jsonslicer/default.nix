{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
  unittestCheckHook,
  setuptools,
  pkg-config,
  yajl,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsonslicer";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AMDmi3";
    repo = "jsonslicer";
    tag = finalAttrs.version;
    hash = "sha256-nPifyqr+MaFqoCYFbFSSBDjvifpX0CFnHCdMCvhwYTA=";
  };

  build-system = [
    setuptools
    pkg-config
  ];

  buildInputs = [ yajl ];

  nativeCheckInputs = [
    pytestCheckHook
    unittestCheckHook
  ];

  pythonImportsCheck = [ "jsonslicer" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Stream JSON parser for Python";
    homepage = "https://github.com/AMDmi3/jsonslicer";
    changelog = "https://github.com/AMDmi3/jsonslicer/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
