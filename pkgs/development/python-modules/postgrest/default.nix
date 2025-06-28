{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  httpx,
  h2,
  deprecation,
  pydantic,
  strenum,
}:

buildPythonPackage rec {
  pname = "postgrest";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-87s+jEYCd1x1yESjH1ZfXz3VhN9NNtaD8LZ9Aahr4yI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    h2
    deprecation
    pydantic
    strenum
  ];

  pythonImportsCheck = [ "postgrest" ];

  # tests aren't in the pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/postgrest-py";
    description = "PostgREST client for Python. This library provides an ORM interface to PostgREST.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siegema ];
  };
}
