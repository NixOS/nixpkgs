{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  mlarray,
  napari-bboxes,
  numpy,
  scipy,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "napari-mlarray";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "napari-mlarray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6NFMR3OZ8zbgBXGA6tL0hvYHQETFYQlTMdDchPfLVXw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    mlarray
    napari-bboxes
    numpy
    scipy
  ];

  pythonImportsCheck = [
    "napari_mlarray"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "A reader/writer Napari plugin for MLArray images";
    homepage = "https://github.com/MIC-DKFZ/napari-mlarray";
    changelog = "https://github.com/MIC-DKFZ/napari-mlarray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
