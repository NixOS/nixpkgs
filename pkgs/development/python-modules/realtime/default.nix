{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  python-dateutil,
  typing-extensions,
  websockets,
  aiohttp,
  pytestCheckHook,
  python-dotenv,
}:

buildPythonPackage rec {
  pname = "realtime-py";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "realtime-py";
    rev = "v${version}";
    hash = "sha256-NFxWcnt/zpgDehacqK7QlXhmjrh6JoA6xh+sFjD/tt0=";
  };

  dependencies = [
    python-dateutil
    typing-extensions
    websockets
    aiohttp
  ];

  pythonRelaxDeps = [
    "websockets"
    "aiohttp"
    "typing-extensions"
  ];

  # Can't run all the tests due to infinite loop in pytest-asyncio
  nativeBuildInputs = [
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "realtime" ];

  build-system = [ poetry-core ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/realtime-py";
    license = lib.licenses.mit;
    description = "Python Realtime Client for Supabase";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
