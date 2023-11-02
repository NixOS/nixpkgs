{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, jsonschema
, peewee
, platformdirs
, iso8601
, rfc3339-validator
, strict-rfc3339
, tomlkit
, deprecation
, timeslot
, pytestCheckHook
, gitUpdater
}:

buildPythonPackage rec {
  pname = "aw-core";
  version = "0.5.16";

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-core";
    rev = "v${version}";
    sha256 = "sha256-7xT7bOGzH5G4WpgNo8pDyiQqX0dWNLNHpgssozUa9kQ=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    peewee
    platformdirs
    iso8601
    rfc3339-validator
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Core library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-core";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mpl20;
  };
}
