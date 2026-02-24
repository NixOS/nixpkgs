{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  typing-extensions,
  websockets,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
}:

buildPythonPackage rec {
  pname = "realtime-py";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "realtime-py";
    tag = "v${version}";
    hash = "sha256-cWWgVs+ZNRvBje3kuDQS5L5utkY3z7MluGFNmjf9LFc=";
  };

  dependencies = [
    pydantic
    typing-extensions
    websockets
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "realtime" ];

  build-system = [ poetry-core ];

  # requires running Supabase
  doCheck = false;

  meta = {
    changelog = "https://github.com/supabase/realtime-py/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/supabase/realtime-py";
    license = lib.licenses.mit;
    description = "Python Realtime Client for Supabase";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
