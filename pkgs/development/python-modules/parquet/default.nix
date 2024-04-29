{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-snappy
, pythonOlder
, setuptools
, thriftpy2
}:

buildPythonPackage rec {
  pname = "parquet";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jcrobak";
    repo = "parquet-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-WVDffYKGsyepK4w1d4KUUMmxB6a6ylTbJvG79Bt5G6o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-snappy
    thriftpy2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Fails with AttributeError
    "test_bson"
    "testFromExample"
  ];

  pythonImportsCheck = [ "thriftpy2" ];

  meta = with lib; {
    description = "Python implementation of the parquet columnar file format";
    homepage = "https://github.com/jcrobak/parquet-python";
    changelog = "https://github.com/jcrobak/parquet-python/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "parquet";
  };
}
