{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dotenv,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "realtime";
  version = "3.0.0a1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pvu2zyRKS99/KEIWwQXBR7Moegt0KITiaMWi5mi+CL4=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/realtime";

  pythonRelaxDeps = [ "websockets" ];

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    typing-extensions
    websockets
  ];

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "realtime" ];

  disabledTestPaths = [
    "tests/test_connection.py"
    "tests/test_presence.py"
  ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siegema ];
  };
})
