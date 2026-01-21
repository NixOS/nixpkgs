{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gym-notices";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "gym_notices";
    inherit version;
    hash = "sha256-n5R372iowV5CYl1PpTYxI34+aulH8yW1wUnAgUma3Bs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "gym_notices" ];

  meta = {
    description = "Notices for Python package Gym";
    homepage = "https://github.com/Farama-Foundation/gym-notices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ billhuang ];
  };
}
