{ lib
, aiobotocore
, boto3
, buildPythonPackage
<<<<<<< HEAD
, dvc-objects
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, flatten-dict
, pythonRelaxDepsHook
, s3fs
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-s3";
<<<<<<< HEAD
  version = "2.23.0";
=======
  version = "2.22.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-HyhZj1sN70o1CTNCiroGKjaMk7tBGqPG2PRsrnm1uVc=";
=======
    hash = "sha256-19j/JD8KZEQKaj55HYEucHwh/LUJ+88PPFEqAWov2Gg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  # dvc-s3 uses boto3 directly, we add in propagatedBuildInputs
  postPatch = ''
    substituteInPlace setup.cfg --replace 'aiobotocore[boto3]' 'aiobotocore'
  '';

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiobotocore boto3 dvc-objects flatten-dict s3fs
=======
    aiobotocore boto3 flatten-dict s3fs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Network access is needed for tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "dvc_s3" ];
=======
  pythonCheckImports = [ "dvc_s3" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "s3 plugin for dvc";
    homepage = "https://pypi.org/project/dvc-s3/${version}";
    changelog = "https://github.com/iterative/dvc-s3/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
