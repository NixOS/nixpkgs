{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-expects-json";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Fischerfredl";
    repo = pname;
    rev = version;
    hash = "sha256-CUxuwqjjAb9Fy6xWtX1WtSANYaYr5//vY8k89KghYoQ=";
  };

  propagatedBuildInputs = [
    flask
    jsonschema
  ] ++ flask.optional-dependencies.async;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_expects_json" ];

  disabledTests = [
    # https://github.com/Fischerfredl/flask-expects-json/issues/26
    "test_check_mimetype"
    "test_default_behaviour"
    "test_default_gets_validated"
    "test_format_validation_rejection"
    "test_ignore_multiple"
    "test_ignore_one"
    "test_valid_decorator_no_schema_async"
    "test_valid_decorator"
    "test_validation_invalid"
  ];

  meta = with lib; {
    homepage = "https://github.com/fischerfredl/flask-expects-json";
    description = "Decorator for REST endpoints in flask. Validate JSON request data.";
    license = licenses.mit;
    maintainers = [ ];
  };
}
