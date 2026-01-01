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

buildPythonPackage rec {
  pname = "jsonslicer";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AMDmi3";
    repo = "jsonslicer";
    tag = version;
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

<<<<<<< HEAD
  meta = {
    description = "Stream JSON parser for Python";
    homepage = "https://github.com/AMDmi3/jsonslicer";
    changelog = "https://github.com/AMDmi3/jsonslicer/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
=======
  meta = with lib; {
    description = "Stream JSON parser for Python";
    homepage = "https://github.com/AMDmi3/jsonslicer";
    changelog = "https://github.com/AMDmi3/jsonslicer/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jopejoe1 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
