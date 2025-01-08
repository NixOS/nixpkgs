{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysuez";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    tag = version;
    hash = "sha256-p9kTWaSMRgKZFonHTgT7nj4NdeTFCeEHawIFew/rii4=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysuez" ];

  meta = with lib; {
    description = "Module to get water consumption data from Suez";
    mainProgram = "pysuez";
    homepage = "https://github.com/jb101010-2/pySuez";
    changelog = "https://github.com/jb101010-2/pySuez/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
