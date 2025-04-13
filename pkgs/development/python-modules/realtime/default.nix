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
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jndhbYxyHw8X6golb2tc1tYmsOtmswVUTV8zDDptmkw=";
  };

  dependencies = [
    python-dateutil
    typing-extensions
    websockets
    aiohttp
  ];

  pythonRelaxDeps = [ "websockets" ];

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
