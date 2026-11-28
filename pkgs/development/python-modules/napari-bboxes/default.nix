{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  napari,
  numpy,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "napari-bboxes";
  version = "0.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Karol-G";
    repo = "napari-bboxes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I1QfPXscAs29QYVBx5G6tajwMcNIcsiZdbqCTWQ9mvo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    napari
    numpy
  ];

  pythonImportsCheck = [
    "napari_bboxes"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Axis-aligned 2D and 3D bounding boxes as Napari layers";
    homepage = "https://github.com/Karol-G/napari-bboxes";
    changelog = "https://github.com/Karol-G/napari-bboxes/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
