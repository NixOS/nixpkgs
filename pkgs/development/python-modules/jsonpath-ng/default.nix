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
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    # missing tag https://github.com/h2non/jsonpath-ng/issues/114
    rev = "cce4a3d4063ac8af928795acc53beb27a2bfd101";
    hash = "sha256-+9iQHQs5TQhZFeIqMlsa3FFPfZEktAWy1lSdJU7kZrc=";
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
