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
  version = "3.0.0a1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-Pvu2zyRKS99/KEIWwQXBR7Moegt0KITiaMWi5mi+CL4=";
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
