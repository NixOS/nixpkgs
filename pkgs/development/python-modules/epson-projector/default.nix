{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "epson-projector";
  version = "0.4.2";

  src = fetchPypi {
    pname = "epson_projector";
    inherit version;
    sha256 = "4ade1c7a0f7008d23b08bd886c8790c44cf7d60453d1eb5a8077c92aaf790d30";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pyserial-asyncio
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
