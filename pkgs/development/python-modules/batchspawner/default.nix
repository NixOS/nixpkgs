{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, isPy27
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    rev = "v${version}";
    sha256 = "0zv485b7fk5zlwgp5fyibanqzbpisdl2a0gz70fwdj4kl462axnw";
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
