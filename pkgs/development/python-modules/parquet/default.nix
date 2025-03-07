{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  python-snappy,
  pythonOlder,
  setuptools,
  thriftpy2,
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

  patches = [
    # Refactor deprecated unittest aliases, https://github.com/jcrobak/parquet-python/pull/83
    (fetchpatch {
      name = "unittest-aliases.patch";
      url = "https://github.com/jcrobak/parquet-python/commit/746bebd1e84d8945a3491e1ae5e44102ff534592.patch";
      hash = "sha256-4awxlzman/YMfOz1WYNR+mVn1ixGku9sqlaMJ1QITYs=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    python-snappy
    thriftpy2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
