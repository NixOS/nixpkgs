{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, packaging
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
    packaging
  ];

  # Tests require a job scheduler e.g. slurm, pbs, etc.
  doCheck = false;

  pythonImportsCheck = [
    "batchspawner"
  ];

  meta = with lib; {
    description = "A spawner for Jupyterhub to spawn notebooks using batch resource managers";
    homepage = "https://github.com/jupyterhub/batchspawner";
    changelog = "https://github.com/jupyterhub/batchspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
