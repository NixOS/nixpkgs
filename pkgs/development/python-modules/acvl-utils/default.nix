{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  batchgenerators,
  blosc2,
  connected-components-3d,
  numpy,
  scikit-image,
  simpleitk,
  torch,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "acvl-utils";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "acvl_utils";
    tag = "v${version}";
    hash = "sha256-52cPL5P6cJo4uqvm5pfYInyDmunATimkYDQ+JL/Mhu4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    batchgenerators
    blosc2
    connected-components-3d
    numpy
    scikit-image
    simpleitk
    torch
    tqdm
  ];

  pythonImportsCheck = [ "acvl_utils" ];

  pytestFlagsArray = [ "tests" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities for medical imaging and deep learning from the ACVL lab";
    homepage = "https://github.com/MIC-DKFZ/acvl_utils";
    changelog = "https://github.com/MIC-DKFZ/acvl_utils/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
