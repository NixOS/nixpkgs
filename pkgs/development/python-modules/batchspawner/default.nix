{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
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
  ];

  # Tests require a job scheduler e.g. slurm, pbs, etc.
  doCheck = false;

  pythonImportsCheck = [
    "batchspawner"
  ];

  meta = with lib; {
    description = "A spawner for Jupyterhub to spawn notebooks using batch resource managers";
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
