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
  version = "3.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
    hash = "sha256-k/ZqDxbC4kc+oVOgHIhPx7kaxzOjF1KukuD5hlWhtEA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ msgpack ];

  optional-dependencies = {
    compression = [
      lz4
      zstandard
    ];
    elastic = [ elasticsearch ];
    avro = [ fastavro ] ++ fastavro.optional-dependencies.snappy;
  };

  nativeCheckInputs = [
    pytest7CheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
