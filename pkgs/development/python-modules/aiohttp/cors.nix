{lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder, typing, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.5.3";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "11b51mhr7wjfiikvj3nc5s8c7miin2zdhl3yrzcga4mbpkj892in";
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
