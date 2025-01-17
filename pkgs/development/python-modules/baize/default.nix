{
  buildPythonPackage,
  lib,
  fetchPypi,
  pytestCheckHook,
  pdm-pep517,
  pytest-httpx,
  setuptools,
  starlette,
  anyio,
  pytest-asyncio,
  pytest-tornasync,
  pytest-trio,
  pytest-twisted,
  twisted,
}:

buildPythonPackage rec {
  pname = "baize";
  version = "0.22.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J+l8NsSTpCh7Uws+Zp45LXkLEBBurqOsOr8Iik/9smY=";
  };

  build-system = [
    pdm-pep517
    setuptools
  ];

  dependencies = [
    starlette
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
    anyio
    pytest-asyncio
    pytest-tornasync
    pytest-trio
    pytest-twisted
    twisted
  ];

  disabledTests = [
    # https://github.com/abersheeran/baize/issues/67
    "test_files"
    "test_request_response"
  ];

  meta = {
    description = "Powerful and exquisite WSGI/ASGI framework/toolkit";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    homepage = "https://baize.aber.sh/";
    license = lib.licenses.asl20;
  };
}
