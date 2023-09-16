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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    # missing tag https://github.com/h2non/jsonpath-ng/issues/114
    rev = "refs/tags/v${version}";
    hash = "sha256-q4kIH/2+VKdlSa+IhJ3ymHpc5gmml9lW4aJS477/YSo=";
  };

  propagatedBuildInputs = [
    decorator
    ply
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
