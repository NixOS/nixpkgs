{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, chardet
, multidict
, async-timeout
, yarl
, pytest
, gunicorn
, pytest-raisesregexp
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "2.3.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42373fbdbe8f09233c17e74f53cee877bc7d5b495b4fc14c32a119255e85e736";
  };

  disabled = pythonOlder "3.4";

  doCheck = false; # Too many tests fail.

  checkInputs = [ pytest gunicorn pytest-raisesregexp ];
  propagatedBuildInputs = [ async-timeout chardet multidict yarl ];

  meta = {
    description = "Http client/server for asyncio";
    license = with lib.licenses; [ asl20 ];
    homepage = https://github.com/KeepSafe/aiohttp/;
  };
}