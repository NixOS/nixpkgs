{ lib
, buildPythonPackage
, environs
, fetchFromGitHub
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
}:

buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.2.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Oqwa/2UT9jyGaEEzjr/phZZStLOZ6JRj+4ck0tmP0W0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "grpcio"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
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
