{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "medvol";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "medvol";
    tag = "v${version}";
    hash = "sha256-U73Whle2/4QwlU9MyRclB5o+pHWdpbCCiYJIdMsMoMg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    simpleitk
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "medvol" ];

  meta = {
    description = "Wrapper for loading medical 3D image volumes such as NIFTI or NRRD images";
    homepage = "https://github.com/MIC-DKFZ/medvol";
    changelog = "https://github.com/MIC-DKFZ/MedVol/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
