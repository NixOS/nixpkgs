{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, importlib-resources
, pyyaml

# tests
, pytestCheckHook
}:

let
  pname = "hassil";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-udOkZILoba2+eR8oSFThsB846COaIXawwRYhn261mCA=";
=======
    hash = "sha256-rCSVKFIkfPg2aYFwuYVLMxMO8S11dV8f4eckpFbNB3k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyyaml
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog  = "https://github.com/home-assistant/hassil/releases/tag/v${version}";
    description = "Intent parsing for Home Assistant";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
