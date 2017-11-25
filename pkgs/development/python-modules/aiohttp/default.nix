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
  version = "2.3.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a2e33e90560dacb819b095b9d9611597925d75d1b93dd9490055d3826d98a82";
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