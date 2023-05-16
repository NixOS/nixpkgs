{ lib
<<<<<<< HEAD
, aiohttp
, asgiref
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, django
, djangorestframework
, falcon
, fetchFromGitHub
, flask
, httpx
, isodate
<<<<<<< HEAD
, jsonschema
, jsonschema-spec
=======
, jsonschema-spec
, mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, more-itertools
, openapi-schema-validator
, openapi-spec-validator
, parse
<<<<<<< HEAD
, poetry-core
, pytest-aiohttp
=======
, pathable
, poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, responses
, requests
, starlette
<<<<<<< HEAD
=======
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, webob
, werkzeug
}:

buildPythonPackage rec {
  pname = "openapi-core";
<<<<<<< HEAD
  version = "0.18.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.17.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-2OcGaZQwzgxcwrXinmJjFc91620Ri0O79c8WZWfDdlQ=";
=======
    hash = "sha256-xlrG2FF55qDsrkdSqCBLu3/QLtZs48ZUB90B2CemY64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    isodate
    more-itertools
<<<<<<< HEAD
    parse
    openapi-schema-validator
    openapi-spec-validator
    werkzeug
    jsonschema-spec
    asgiref
    jsonschema
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
=======
    pathable
    more-itertools
    openapi-schema-validator
    jsonschema-spec
    openapi-spec-validator
    typing-extensions
    parse
    werkzeug
  ];

  passthru.optional-dependencies = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    django = [
      django
    ];
    falcon = [
      falcon
    ];
    flask = [
      flask
    ];
    requests = [
      requests
    ];
    starlette = [
      httpx
      starlette
    ];
  };

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
=======
  nativeCheckInputs = [
    mock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    responses
    webob
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # Requires secrets and additional configuration
    "tests/integration/contrib/django/"
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
