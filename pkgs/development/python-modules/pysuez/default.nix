{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  regex,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysuez";
  version = "1.3.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    tag = version;
    hash = "sha256-BG5nX2S+WV0Bdwm/cvm+mGO1RUd+F312tZ4jws6A/d8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    regex
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysuez" ];

  meta = with lib; {
    description = "Module to get water consumption data from Suez";
    mainProgram = "pysuez";
    homepage = "https://github.com/jb101010-2/pySuez";
    changelog = "https://github.com/jb101010-2/pySuez/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
