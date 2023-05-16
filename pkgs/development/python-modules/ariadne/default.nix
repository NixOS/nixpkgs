{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hatchling
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, freezegun
, graphql-core
, opentracing
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, snapshottest
, starlette
, typing-extensions
, werkzeug
}:

buildPythonPackage rec {
  pname = "ariadne";
  version = "0.18.1";
<<<<<<< HEAD
  format = "pyproject";
=======
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-E7uC+l0Yjol8UPLF4CV+PN49tOUJXNUS5yYdF1oyfwU=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    hatchling
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    graphql-core
    starlette
    typing-extensions
  ];

  nativeCheckInputs = [
    freezegun
    opentracing
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    snapshottest
    werkzeug
  ];

  pythonImportsCheck = [
    "ariadne"
  ];

  disabledTests = [
    # TypeError: TestClient.request() got an unexpected keyword argument 'content'
    "test_attempt_parse_request_missing_content_type_raises_bad_request_error"
    "test_attempt_parse_non_json_request_raises_bad_request_error"
    "test_attempt_parse_non_json_request_body_raises_bad_request_error"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # missing graphql-sync-dataloader test dep
    "tests/test_dataloaders.py"
    "tests/wsgi/test_configuration.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python library for implementing GraphQL servers using schema-first approach";
    homepage = "https://ariadnegraphql.org";
    changelog = "https://github.com/mirumee/ariadne/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
