{
  lib,
  buildPythonPackage,
  elasticsearch,
  fastavro,
  fetchFromGitHub,
  lz4,
  msgpack,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "flow-record";
  version = "3.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
    hash = "sha256-j5N66p7feB9Ae+Fu5RhVzh8XCHiq55jJMg0Fe+C6Jvg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ msgpack ];

  passthru.optional-dependencies = {
    compression = [
      lz4
      zstandard
    ];
    elastic = [ elasticsearch ];
    avro = [ fastavro ] ++ fastavro.optional-dependencies.snappy;
  };

  nativeCheckInputs = [
    pytest7CheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "flow.record" ];

  disabledTestPaths = [
    # Test requires rdump
    "tests/test_rdump.py"
  ];

  disabledTests = [ "test_rdump_fieldtype_path_json" ];

  meta = with lib; {
    description = "Library for defining and creating structured data";
    homepage = "https://github.com/fox-it/flow.record";
    changelog = "https://github.com/fox-it/flow.record/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
