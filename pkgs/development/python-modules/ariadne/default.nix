{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  graphql-core,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  python-multipart,
  starlette,
  syrupy,
  typing-extensions,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "ariadne";
  version = "0.23.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "ariadne";
    rev = "refs/tags/${version}";
    hash = "sha256-zdM6LKtrD6m3hWn90yAgsinCvaa86BaTdhgf/VzGDLA=";
  };

  patches = [ ./remove-opentracing.patch ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    graphql-core
    starlette
    typing-extensions
  ];

  nativeCheckInputs = [
    freezegun
    httpx
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    python-multipart
    syrupy
    werkzeug
  ];

  pythonImportsCheck = [ "ariadne" ];

  pytestFlagsArray = [ "--snapshot-update" ];

  disabledTests = [
    # TypeError: TestClient.request() got an unexpected keyword argument 'content'
    "test_attempt_parse_request_missing_content_type_raises_bad_request_error"
    "test_attempt_parse_non_json_request_raises_bad_request_error"
    "test_attempt_parse_non_json_request_body_raises_bad_request_error"
    # opentracing
    "test_query_is_executed_for_multipart_form_request_with_file"
    "test_query_is_executed_for_multipart_request_with_large_file_with_tracing"
  ];

  disabledTestPaths = [
    # missing graphql-sync-dataloader test dep
    "tests/test_dataloaders.py"
    "tests/wsgi/test_configuration.py"
    # both include opentracing module, which has been removed from nixpkgs
    "tests/tracing/test_opentracing.py"
    "tests/tracing/test_opentelemetry.py"
  ];

  meta = with lib; {
    description = "Python library for implementing GraphQL servers using schema-first approach";
    homepage = "https://ariadnegraphql.org";
    changelog = "https://github.com/mirumee/ariadne/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
