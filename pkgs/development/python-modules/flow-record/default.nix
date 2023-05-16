{ lib
, buildPythonPackage
, elasticsearch
<<<<<<< HEAD
, fastavro
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "3.11";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "flow.record";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-/mrsm7WoqnTIaGOHuIZk1eMXAMi38eVpctgi6+RQ3WQ=";
=======
    hash = "sha256-hvd5I1n3lOuP9sUtVO69yGCVOVEWYKKfFf7OjAJCXIg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    avro = [
      fastavro
    ] ++ fastavro.optional-dependencies.snappy;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "flow.record"
  ];

  disabledTestPaths = [
    # Test requires rdump
    "tests/test_rdump.py"
  ];

<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
