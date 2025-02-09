{ lib
, buildPythonPackage
, elasticsearch
, fastavro
, fetchFromGitHub
, lz4
, msgpack
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, wheel
, zstandard
}:

buildPythonPackage rec {
  pname = "flow-record";
  version = "3.13";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
    hash = "sha256-Yg42nA0dRjHormpmpbOuZYuvBpNz9XEpf84XI2iJpYY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    msgpack
  ];

  passthru.optional-dependencies = {
    compression = [
      lz4
      zstandard
    ];
    elastic = [
      elasticsearch
    ];
    avro = [
      fastavro
    ] ++ fastavro.optional-dependencies.snappy;
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "flow.record"
  ];

  disabledTestPaths = [
    # Test requires rdump
    "tests/test_rdump.py"
  ];

  disabledTests = [
    "test_rdump_fieldtype_path_json"
  ];

  meta = with lib; {
    description = "Library for defining and creating structured data";
    homepage = "https://github.com/fox-it/flow.record";
    changelog = "https://github.com/fox-it/flow.record/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
