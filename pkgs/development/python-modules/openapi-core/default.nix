{ lib
, buildPythonPackage
, django
, djangorestframework
, falcon
, fetchFromGitHub
, fetchpatch
, flask
, isodate
, jsonschema-spec
, more-itertools
, openapi-schema-validator
, openapi-spec-validator
, parse
, pathable
, poetry-core
, pytestCheckHook
, pythonOlder
, responses
, typing-extensions
, webob
, werkzeug
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = version;
    hash = "sha256-7RjKll+z9wrax9hLS4cKpQLOvmlD+lXbk9CkZi0oSbw=";
  };

  postPatch = ''
    # Remove arguments for pytest plugins
    substituteInPlace pyproject.toml \
      --replace "--cov=openapi_core" "" \
      --replace "--cov-report=term-missing" "" \
      --replace "--cov-report=xml" ""
  '';

  patches = [
    # Fix for openapi-spec-validator >=0.5.0
    (fetchpatch {
      name = "switch-to-jsonschema-spec.patch";
      url = "https://github.com/p1c2u/openapi-core/commit/202c5b62b58b488eb9ce04a7791623748f23f19b.patch";
      hash = "sha256-3vc4QnQEi96xUESo+27qQlzPMvC0FS7qZmXy8AWZt28=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    isodate
    jsonschema-spec
    more-itertools
    openapi-schema-validator
    openapi-spec-validator
    pathable
    parse
    werkzeug
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  checkInputs = [
    django
    djangorestframework
    falcon
    flask
    pytestCheckHook
    responses
    webob
  ];

  pythonImportsCheck = [
    "openapi_core"
    "openapi_core.validation.request.validators"
    "openapi_core.validation.response.validators"
  ];

  meta = with lib; {
    description = "Client-side and server-side support for the OpenAPI Specification v3";
    homepage = "https://github.com/p1c2u/openapi-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
