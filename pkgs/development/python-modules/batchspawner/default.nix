{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterhub
, packaging
, pythonOlder
}:

buildPythonPackage rec {
  pname = "batchspawner";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "batchspawner";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z7kB8b7s11wokTachLI/N+bdUV+FfCRTemL1KYQpzio=";
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
    mainProgram = "batchspawner-singleuser";
    homepage = "https://github.com/jupyterhub/batchspawner";
    changelog = "https://github.com/jupyterhub/batchspawner/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
