{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "epson-projector";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "epson_projector";
    inherit version;
    hash = "sha256-LwsdMuwvLifIP1PRNhfLi4TTZRp/cw9Bcf57vrsNrbI=";
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
