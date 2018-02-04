{lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder, typing, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r0mb4dw0dc1lpi54dk5vxqs06nyhvagp76lyrvk7rd94z5mjkd4";
  };

  # Requires network access
  doCheck = false;

  propagatedBuildInputs = [ aiohttp ]
  ++ lib.optional (pythonOlder "3.5") typing;

  meta = with lib; {
    description = "CORS support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-cors";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
