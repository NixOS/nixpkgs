{ lib
, buildPythonPackage
, decorator
, fetchFromGitHub
, ply
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "jsonpath-ng";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cxjwhx0nj85a3awnl7j6afnk07awzv45qfwxl5jqbbc9cxh5bd6";
  };

  propagatedBuildInputs = [
    decorator
    ply
    six
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Exclude tests that require oslotest
    "tests/test_jsonpath_rw_ext.py"
  ];

  pythonImportsCheck = [ "jsonpath_ng" ];

  meta = with lib; {
    description = "JSONPath implementation for Python";
    homepage = "https://github.com/h2non/jsonpath-ng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
