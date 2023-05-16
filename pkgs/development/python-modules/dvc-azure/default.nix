{ lib
, adlfs
, azure-identity
, buildPythonPackage
<<<<<<< HEAD
, dvc-objects
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, knack
, pythonRelaxDepsHook
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-azure";
<<<<<<< HEAD
  version = "2.22.1";
=======
  version = "2.21.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-v3VRCN1OoST5RlfUOP9Dpfmf3o9C/ckusmh91Ya2Cik=";
=======
    hash = "sha256-0PB+2lPAV2yy2hivDDz0PXmi8WqoSlUZadyfKPp9o1g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    adlfs azure-identity dvc-objects knack
=======
    adlfs azure-identity knack
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Network access is needed for tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "dvc_azure" ];
=======
  pythonCheckImports = [ "dvc_azure" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "azure plugin for dvc";
    homepage = "https://pypi.org/project/dvc-azure/${version}";
    changelog = "https://github.com/iterative/dvc-azure/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
