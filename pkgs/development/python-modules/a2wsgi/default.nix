{
  lib,
  buildPythonPackage,
  fetchPypi,
  baize,
  httpx,
  pdm-backend,
  pytest-asyncio,
  pytestCheckHook,
  starlette,
}:

buildPythonPackage rec {
  pname = "a2wsgi";
  version = "1.10.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zkYv9+HarAvFcYPG+ADwmnHCp6mN3VzeyhSePqvzM44=";
  };

  build-system = [ pdm-backend ];

  nativeCheckInputs = [
    baize
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  meta = with lib; {
    description = "Convert WSGI app to ASGI app or ASGI app to WSGI app";
    homepage = "https://github.com/abersheeran/a2wsgi";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
