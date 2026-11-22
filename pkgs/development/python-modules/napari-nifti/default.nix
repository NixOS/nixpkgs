{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  napari-mlarray,
  medvol,
  numpy,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "napari-nifti";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "napari-nifti";
    tag = "v${version}";
    hash = "sha256-vR0Wy6MN0GsWUIawT9u8ufltIPaa+j75WoWJcziAY8A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    medvol
    napari-mlarray
    numpy
  ]
  ++ medvol.optional-dependencies.dicom;

  pythonImportsCheck = [ "napari_nifti" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Napari plugin for reading and writing NIFTI files";
    homepage = "https://github.com/MIC-DKFZ/napari-nifti";
    changelog = "https://github.com/MIC-DKFZ/napari-nifti/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
