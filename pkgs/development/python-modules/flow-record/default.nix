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
, zstandard
}:

buildPythonPackage rec {
  pname = "flow-record";
  version = "3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = version;
    hash = "sha256-hULz5pIqCKujVH3SpzFgzNM9R7WTtqAmuNOxG7VlUd0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
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

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flow.record"
  ];

  disabledTestPaths = [
    # Test requires rdump
    "tests/test_rdump.py"
  ];

  meta = with lib; {
    description = "Library for defining and creating structured data";
    homepage = "https://github.com/fox-it/flow.record";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
