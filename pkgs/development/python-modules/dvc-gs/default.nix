{ lib
, buildPythonPackage
, dvc-objects
, fetchPypi
, gcsfs
, pythonRelaxDepsHook
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-gs";
<<<<<<< HEAD
  version = "2.22.1";
=======
  version = "2.22.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-IKDwdSfolZwv8TvHHicVV42PYeULhskv8csbkiJzLbk=";
=======
    hash = "sha256-UzYW2iU/GvLJd4q6ErcLQRoAehyFF3PrMTjb8PEtmNE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [ gcsfs dvc-objects ];

  # Network access is needed for tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "dvc_gs" ];
=======
  pythonCheckImports = [ "dvc_gs" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "gs plugin for dvc";
    homepage = "https://pypi.org/project/dvc-gs/version";
    changelog = "https://github.com/iterative/dvc-gs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
