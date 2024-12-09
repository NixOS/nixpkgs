{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  jsonschema,
  peewee,
  platformdirs,
  iso8601,
  rfc3339-validator,
  strict-rfc3339,
  tomlkit,
  deprecation,
  timeslot,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "aw-core";
  version = "0.5.17";

  format = "pyproject";

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-core";
    rev = "v${version}";
    sha256 = "sha256-bKxf+fqm+6V3JgDluKVpqq5hRL3Z+x8SHMRQmNe8vUA=";
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

  pythonRelaxDeps = [
    "platformdirs"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Fake home folder for tests that write to $HOME
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "aw_core" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Core library for ActivityWatch";
    mainProgram = "aw-cli";
    homepage = "https://github.com/ActivityWatch/aw-core";
    maintainers = with lib.maintainers; [ huantian ];
    license = lib.licenses.mpl20;
  };
}
