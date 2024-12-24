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
  version = "1.3.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    rev = "refs/tags/${version}";
    hash = "sha256-BG5nX2S+WV0Bdwm/cvm+mGO1RUd+F312tZ4jws6A/d8=";
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
