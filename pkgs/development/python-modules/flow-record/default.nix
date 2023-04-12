{ lib
, buildPythonPackage
, elasticsearch
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
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
    hash = "sha256-hvd5I1n3lOuP9sUtVO69yGCVOVEWYKKfFf7OjAJCXIg=";
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
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
