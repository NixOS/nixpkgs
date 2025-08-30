{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  deprecation,
  h2,
  httpx,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pythonPackages,
}:

buildPythonPackage rec {
  pname = "postgrest";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "postgrest-py";
    tag = "v${version}";
    hash = "sha256-WTS8J8XhHPSe6N1reY3j2QYHaRY1goiVoqQCUKSgbVY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    deprecation
    httpx
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    h2
  ];

  # Lots of tests fail without network access
  disabledTestPaths = [
    "tests/_async/test_client.py"
    "tests/_async/test_filter_request_builder.py"
    "tests/_async/test_filter_request_builder_integration.py"
    "tests/_async/test_query_request_builder.py"
    "tests/_async/test_request_builder.py"
    "tests/_sync/test_filter_request_builder_integration.py"
  ];
  disabledTests = [
    "test_params_purged_after_execute"
  ];

  pythonImportsCheck = [ "postgrest" ];

  meta = {
    description = "PostgREST client for Python, provides an ORM interface to PostgREST";
    homepage = "https://github.com/supabase/postgrest-py";
    changelog = "https://github.com/supabase/postgrest-py/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
