{
  lib,
  buildPythonPackage,
  environs,
  fetchFromGitHub,
  gitpython,
  grpcio,
  grpcio-testing,
  minio,
  mmh3,
  pandas,
  pyarrow,
  pytestCheckHook,
  pythonOlder,
  requests,
  scikit-learn,
  setuptools-scm,
  ujson,
  wheel,
}:

buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.5.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = "pymilvus";
    tag = "v${version}";
    hash = "sha256-oWuaxiiwheJ7lGPN+nUOGuJLgoZORDmM8h8ND6D3uII=";
  };

  pythonRelaxDeps = [
    "environs"
    "grpcio"
  ];

  nativeBuildInputs = [
    gitpython
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    environs
    grpcio
    minio
    mmh3
    pandas
    pyarrow
    requests
    ujson
  ];

  nativeCheckInputs = [
    grpcio-testing
    pytestCheckHook
    scikit-learn
  ];

  pythonImportsCheck = [ "pymilvus" ];

  disabledTests = [ "test_get_commit" ];

  meta = with lib; {
    description = "Python SDK for Milvus";
    homepage = "https://github.com/milvus-io/pymilvus";
    changelog = "https://github.com/milvus-io/pymilvus/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
