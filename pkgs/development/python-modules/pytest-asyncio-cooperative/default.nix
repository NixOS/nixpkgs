{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-asyncio-cooperative";
  version = "0.40.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willemt";
    repo = "pytest-asyncio-cooperative";
    tag = "v${version}";
    hash = "sha256-WA2swhgpn7Ct409tk91gQiHUZCXQLO0eznqskOVlU1U=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    "example/hypothesis_test.py"
  ];
  disabledTests = [
    "test_tmp_path"
    "test_session_scope_gen"
    "test_session_scope_async_gen"
    "test_retry"
  ];

  pythonImportsCheck = [ "pytest_asyncio_cooperative" ];

  meta = {
    description = "Use asyncio to run your I/O bound test suite efficiently and quickly";
    homepage = "https://github.com/willemt/pytest-asyncio-cooperative";
    changelog = "https://github.com/willemt/pytest-asyncio-cooperative/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
