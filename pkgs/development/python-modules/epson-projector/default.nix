{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "epson-projector";
  version = "0.4.6";

  src = fetchPypi {
    pname = "epson_projector";
    inherit version;
    sha256 = "sha256-F8Dvk5OtlPbFyIedJb+zM2iN9eT0jDQEs06xbL3rlVs=";
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
