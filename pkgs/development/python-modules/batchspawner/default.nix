{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, isPy27
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    rev = "v${version}";
    sha256 = "0yn312sjfjpjjfciagbczfmqprk2fj4lbb3vsbzj17p948acq5w2";
  };

  propagatedBuildInputs = [
    jupyterhub
  ];

  # tests require a job scheduler e.g. slurm, pbs, etc.
  doCheck = false;

  pythonImportsCheck = [ "batchspawner" ];

  meta = with lib; {
    description = "A spawner for Jupyterhub to spawn notebooks using batch resource managers";
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
