{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  aiohttp,
  attrs,
  multidict,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohttp-sse-client";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UATiknFiSvWGFY3HFmywaHp6WZeqtbgI9LU0AOG3Ljs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    attrs
    multidict
    yarl
  ];

  pythonImportsCheck = [
    "aiohttp_sse_client"
  ];

  meta = {
    description = "Server-Sent Event python client base on aiohttp";
    homepage = "https://pypi.org/project/aiohttp-sse-client/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
