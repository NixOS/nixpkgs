{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, jsonschema
, peewee
, appdirs
, iso8601
, rfc3339-validator
, takethetime
, strict-rfc3339
, tomlkit
, deprecation
, timeslot
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aw-core";
  version = "0.5.12";

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-core";
    rev = "v${version}";
    sha256 = "sha256-DbugVMaQHlHpfbFEsM6kfpDL2VzRs0TDn9klWjAwz64=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    peewee
    appdirs
    iso8601
    rfc3339-validator
    takethetime
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

  meta = with lib; {
    description = "Core library for ActivityWatch";
    homepage = "https://github.com/ActivityWatch/aw-core";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mpl20;
  };
}
