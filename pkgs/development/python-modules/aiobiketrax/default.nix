{ lib
, aiohttp
, auth0-python
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyjwt
, pytest-aiohttp
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "aiobiketrax";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "basilfx";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YvPWvdA4BslkOLt3IkzSgUgex8h1CjCOVZC6oxNf3ZA=";
=======
    hash = "sha256-exxpJJA+JnVuehCnWs/ihk/SSPUqV7ODXZxvbmuHe8U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # https://github.com/basilfx/aiobiketrax/pull/63
    substituteInPlace aiobiketrax/api.py \
      --replace "auth0.v3" "auth0"
  '';

  pythonRelaxDeps = [
    "auth0-python"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    auth0-python
    python-dateutil
    pyjwt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiobiketrax"
  ];

  meta = with lib; {
    description = "Library for interacting with the PowUnity BikeTrax GPS tracker";
    homepage = "https://github.com/basilfx/aiobiketrax";
    changelog = "https://github.com/basilfx/aiobiketrax/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
