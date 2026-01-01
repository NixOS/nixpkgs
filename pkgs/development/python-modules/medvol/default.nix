{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  setuptools,
  numpy,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "medvol";
<<<<<<< HEAD
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "medvol";
    tag = "v${version}";
    hash = "sha256-PUZZRF5KzfvwI335H1tnUtGa2+zdnL6J5NArqQWL7tM=";
=======
  version = "0.0.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "medvol";
    rev = "v${version}";
    hash = "sha256-MMYBPyXXS6hTehyWUcvQso9HBLhWMGWzRDGSTtT1iZc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/MIC-DKFZ/MedVol/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/MIC-DKFZ/MedVol/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
