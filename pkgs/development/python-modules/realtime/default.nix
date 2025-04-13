{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  python-dateutil,
  typing-extensions,
  websockets,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "realtime";
  version = "2.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ROgkB91/z2p3PK75uvkRh8QZ1lOf8AFPAcpLyJoOXFI=";
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

  pythonImportsCheck = [ "realtime" ];

  build-system = [ poetry-core ];

  # tests aren't in the pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/realtime-py";
    license = lib.licenses.mit;
    description = "Python Realtime Client for Supabase";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
