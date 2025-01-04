{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  numpy,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "medvol";
  version = "0.0.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "medvol";
    rev = "v${version}";
    hash = "sha256-JOw0ODx5yuBY5FyXy9z5C/NE/iok5GwiInalgXW/1J8=";
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
    changelog = "https://github.com/MIC-DKFZ/MedVol/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
