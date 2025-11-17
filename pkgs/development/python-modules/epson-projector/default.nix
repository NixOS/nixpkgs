{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  pyserial-asyncio-fast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "epson-projector";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "epson_projector";
    inherit version;
    hash = "sha256-/9Nc3xOxnXFfTsS8s83MXTkVAhqLwrKnmfR/E87s+Bk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyserial-asyncio-fast
  ];

  # tests need real device
  doCheck = false;

  pythonImportsCheck = [
    "epson_projector"
    "epson_projector.const"
    "epson_projector.projector_http"
    "epson_projector.projector_serial"
    "epson_projector.projector_tcp"
  ];

  meta = with lib; {
    description = "Epson projector support for Python";
    homepage = "https://github.com/pszafer/epson_projector";
    changelog = "https://github.com/pszafer/epson_projector/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
