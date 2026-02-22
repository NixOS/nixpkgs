{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  acvl-utils,
  batchgenerators,
  batchgeneratorsv2,
  dicom2nifti,
  dynamic-network-architectures,
  einops,
  graphviz,
  matplotlib,
  nibabel,
  numpy,
  pandas,
  requests,
  scikit-image,
  scikit-learn,
  scipy,
  seaborn,
  simpleitk,
  tifffile,
  torch,
  tqdm,
  yacs,
}:

buildPythonPackage rec {
  pname = "nnunetv2";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "nnUNet";
    tag = "v${version}";
    hash = "sha256-7z7fymvvP+FekltslreM6hRiRYmdHgTZyCThVKmkjYA=";
  };

  # imagecodecs and several of its dependencies are not in Nixpkgs,
  # but it's not actually imported by nnunet
  # (probably used indirectly to allow reading from additional TIFF/JPEG formats)
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"imagecodecs",' ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    acvl-utils
    batchgenerators
    batchgeneratorsv2
    dicom2nifti
    dynamic-network-architectures
    einops
    graphviz
    matplotlib
    nibabel
    numpy
    pandas
    requests
    scikit-image
    scikit-learn
    scipy
    seaborn
    simpleitk
    tifffile
    torch
    tqdm
    yacs
  ];

  pythonImportsCheck = [
    "nnunetv2"
    "nnunetv2.batch_running"
    "nnunetv2.dataset_conversion"
    "nnunetv2.ensembling"
    "nnunetv2.evaluation"
    "nnunetv2.experiment_planning"
    "nnunetv2.imageio"
    "nnunetv2.inference"
    "nnunetv2.model_sharing"
    "nnunetv2.postprocessing"
    "nnunetv2.preprocessing"
    "nnunetv2.run"
    "nnunetv2.training"
    "nnunetv2.utilities"
  ];

  doCheck = false; # see nnunetv2/tests/integration_tests, but too expensive to run

  meta = {
    description = "Automated pipeline for semantic segmentation of medical images";
    homepage = "https://github.com/MIC-DKFZ/nnUNet";
    changelog = "https://github.com/MIC-DKFZ/nnUNet/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
