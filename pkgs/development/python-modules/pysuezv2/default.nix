{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysuezv2";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    tag = version;
    hash = "sha256-D/XsJL393fDIKMB1Wyzods5hLsdU3Qgq8T5aTJ3SLrM=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysuez" ];

  meta = {
    description = "Module for dealing with water consumption data from Suez";
    homepage = "https://github.com/jb101010-2/pySuez";
    changelog = "https://github.com/jb101010-2/pySuez/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
