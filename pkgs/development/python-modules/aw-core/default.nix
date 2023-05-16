{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, jsonschema
, peewee
<<<<<<< HEAD
, platformdirs
, iso8601
, rfc3339-validator
=======
, appdirs
, iso8601
, rfc3339-validator
, takethetime
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, strict-rfc3339
, tomlkit
, deprecation
, timeslot
, pytestCheckHook
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aw-core";
<<<<<<< HEAD
  version = "0.5.15";
=======
  version = "0.5.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-core";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3cz79gSkmbGtCKnLGA4HGG5dLu7QB4ZtMnNGrSYB17U=";
=======
    sha256 = "sha256-DbugVMaQHlHpfbFEsM6kfpDL2VzRs0TDn9klWjAwz64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    peewee
<<<<<<< HEAD
    platformdirs
    iso8601
    rfc3339-validator
=======
    appdirs
    iso8601
    rfc3339-validator
    takethetime
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    strict-rfc3339
    tomlkit
    deprecation
    timeslot
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Fake home folder for tests that write to $HOME
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "aw_core" ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Core library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-core";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mpl20;
  };
}
