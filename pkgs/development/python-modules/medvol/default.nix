{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mlarray,
  nibabel,
  numpy,
  pynrrd,
  simpleitk,
  # optional-dependencies
  highdicom,
  pydicom,
  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "medvol";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "medvol";
    tag = "v${version}";
    hash = "sha256-R8A++5qlTdeSBp5DW7aj8l/JpWEzxqo5EinI7Jm5uy0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mlarray
    nibabel
    numpy
    pynrrd
    simpleitk
  ];

  optional-dependencies.dicom = [
    highdicom
    pydicom
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.dicom;

  pythonImportsCheck = [ "medvol" ];

  meta = {
    description = "Wrapper for loading medical 3D image volumes such as NIFTI or NRRD images";
    homepage = "https://github.com/MIC-DKFZ/medvol";
    changelog = "https://github.com/MIC-DKFZ/MedVol/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
