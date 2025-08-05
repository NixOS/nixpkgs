{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "gym-notices";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n5R372iowV5CYl1PpTYxI34+aulH8yW1wUnAgUma3Bs=";
  };

  pythonImportsCheck = [ "gym_notices" ];

  meta = with lib; {
    description = "Notices for Python package Gym";
    homepage = "https://github.com/Farama-Foundation/gym-notices";
    license = licenses.mit;
    maintainers = with maintainers; [ billhuang ];
  };
}
