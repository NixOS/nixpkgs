{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  click,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "aw-core";
  version = "0.5.18";

  pyproject = true;

  # pypi distribution doesn't include tests, so build from source instead
  src = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "aw-core";
    rev = "v${version}";
    hash = "sha256-v5cCV3NFk7oz04WjbHgxQr4I72/gOUQRcARIcz6zXjo=";
  };

  patches = [
    # Fixes many ParseErrors in tests:
    # "iso8601.iso8601.ParseError: expected string or bytes-like object, got 'datetime.datetime'"
    (fetchpatch {
      name = "datastore-serialize-native-bucket-datetimes.patch";
      url = "https://github.com/ActivityWatch/aw-core/commit/35a48676069e730684421d6ca56e214b163e1fd9.patch";
      hash = "sha256-KTMMdTC2kSZ0+8l5zmf+rDGFwyHJvdPzO7eYevCJUpM=";
    })
  ];

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
    click
  ];

  pythonRelaxDeps = [
    "platformdirs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

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
