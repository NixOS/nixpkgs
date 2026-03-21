{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  aiohttp,
  websockets,
  typing-extensions,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  python-dotenv,
  pytestCheckHook,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "realtime";
  version = "2.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-nK+IZRrKjNy84EC8krBvAZll5E0+jV3bLJh8qIVRElI=";
  };

  sourceRoot = "${src.name}/src/realtime";

  build-system = [ poetry-core ];

  dependencies = [
    websockets
    typing-extensions
    pydantic
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "websockets" ];

  nativeCheckInputs = [
    aiohttp
    pytestCheckHook
    pytest-cov-stub
    python-dotenv
    pytest-asyncio
  ];

  pythonImportsCheck = [ "realtime" ];

  disabledTestPaths = [
    "tests/test_connection.py"
    "tests/test_presence.py"
  ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ siegema ];
    license = lib.licenses.mit;
  };
}
