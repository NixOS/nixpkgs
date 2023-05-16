{ lib
, buildPythonPackage
, environs
, fetchFromGitHub
<<<<<<< HEAD
, gitpython
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, grpcio
, grpcio-testing
, mmh3
, pandas
, pytestCheckHook
, python
, pythonOlder
, pythonRelaxDepsHook
, scikit-learn
, setuptools-scm
, ujson
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pymilvus";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-hp00iUT1atyTQk532z7VAajpfvtnKE8W2la9MW7NxoE=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
    hash = "sha256-Oqwa/2UT9jyGaEEzjr/phZZStLOZ6JRj+4ck0tmP0W0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonRelaxDeps = [
    "grpcio"
  ];

  nativeBuildInputs = [
<<<<<<< HEAD
    gitpython
    pythonRelaxDepsHook
    setuptools-scm
    wheel
=======
    pythonRelaxDepsHook
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    environs
    grpcio
    mmh3
    pandas
    ujson
  ];

  nativeCheckInputs = [
    grpcio-testing
    pytestCheckHook
    scikit-learn
  ];

  pythonImportsCheck = [
    "pymilvus"
  ];

  disabledTests = [
    "test_get_commit"
  ];

  meta = with lib; {
    description = "Python SDK for Milvus";
    homepage = "https://github.com/milvus-io/pymilvus";
    changelog = "https://github.com/milvus-io/pymilvus/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
