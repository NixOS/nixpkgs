{ lib
, buildPythonPackage
, fetchFromGitHub
, ply
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "jsonpath-ng";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-q4kIH/2+VKdlSa+IhJ3ymHpc5gmml9lW4aJS477/YSo=";
  };

  propagatedBuildInputs = [
    ply
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Exclude tests that require oslotest
    "tests/test_jsonpath_rw_ext.py"
  ];

  pythonImportsCheck = [
    "jsonpath_ng"
  ];

  meta = with lib; {
    description = "JSONPath implementation";
    homepage = "https://github.com/h2non/jsonpath-ng";
    changelog = "https://github.com/h2non/jsonpath-ng/blob/v${version}/History.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
