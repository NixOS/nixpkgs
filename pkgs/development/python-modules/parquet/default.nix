{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-snappy
, thriftpy2
}:

buildPythonPackage rec {
  pname = "parquet";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jcrobak";
    repo = "parquet-python";
    rev = "v${version}";
    sha256 = "1ahvg4dz9fzi4vdm9jmslq3v3jahjj17fdcc5fljgcw6h9yxyl2r";
  };

  propagatedBuildInputs = [
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
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
