{ lib, buildPythonPackage, fetchPypi, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pczn54bqd32v8zhfbjfybiza6xh1szwxy6as577dn8g23bwcfad";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "CORS support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-cors";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
