{ lib
, buildPythonPackage
, environs
, fetchFromGitHub
, gitpython
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
, wheel
}:

buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hp00iUT1atyTQk532z7VAajpfvtnKE8W2la9MW7NxoE=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "grpcio"
  ];

  nativeBuildInputs = [
    gitpython
    pythonRelaxDepsHook
    setuptools-scm
    wheel
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
