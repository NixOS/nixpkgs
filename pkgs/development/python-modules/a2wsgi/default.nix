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
  version = "1.10.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/AC6sfx5L4mozhtJGyrRcXsUXYyu+3XQqFhpRu3JfLI=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    starlette
    baize
  ];

  nativeCheckInputs = [
    baize
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  meta = {
    description = "Convert WSGI app to ASGI app or ASGI app to WSGI app";
    homepage = "https://github.com/abersheeran/a2wsgi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
