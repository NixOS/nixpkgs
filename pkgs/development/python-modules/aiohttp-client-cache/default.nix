{
  lib,
  fetchPypi,
  buildPythonPackage,
  poetry-core,
  aiohttp,
  attrs,
  itsdangerous,
  url-normalize,
}:

buildPythonPackage rec {
  pname = "aiohttp_client_cache";
  version = "0.11.1";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MuY60hAkD4Ik8+Encv5TrBAs8kx88Y3bhqy7n9+eS28=";
  };
  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    aiohttp
    attrs
    itsdangerous
    url-normalize
  ];
  meta = with lib; {
    description = "Async persistent cache for aiohttp requests";
    homepage = "https://pypi.org/project/aiohttp-client-cache/";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
  };
}
