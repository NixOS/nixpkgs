{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, mock
, openapi-spec-validator
, prance
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mFbWvJbg7LRC6Z8z4B2XVe/hg1K5i1a8VjKsPd93DJ8=";
  };

  propagatedBuildInputs = [
    pyyaml
    prance
  ];

  nativeCheckInputs = [
    openapi-spec-validator
    marshmallow
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "apispec"
  ];

  disabledTestPaths = [
    # https://github.com/marshmallow-code/apispec/pull/805
    "tests/test_ext_marshmallow_field.py"
    "tests/test_ext_marshmallow.py"
    "tests/test_ext_marshmallow_openapi.py"
  ];

  meta = with lib; {
    description = "A pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    changelog = "https://github.com/marshmallow-code/apispec/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
