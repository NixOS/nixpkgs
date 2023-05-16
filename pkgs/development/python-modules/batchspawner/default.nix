{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
<<<<<<< HEAD
, packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    rev = "refs/tags/v${version}";
    hash = "sha256-oyS47q+gsO7JmRsbVJXglZsSRfits5rS/nrHW5E7EV0=";
  };

  propagatedBuildInputs = [
    jupyterhub
<<<<<<< HEAD
    packaging
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Tests require a job scheduler e.g. slurm, pbs, etc.
  doCheck = false;

  pythonImportsCheck = [
    "batchspawner"
  ];

  meta = with lib; {
    description = "A spawner for Jupyterhub to spawn notebooks using batch resource managers";
<<<<<<< HEAD
    homepage = "https://github.com/jupyterhub/batchspawner";
    changelog = "https://github.com/jupyterhub/batchspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
