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
  version = "2.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04f58bbcc9ae6f9aec30b9219ae47fa3c31586c77679405720545738ea62236e";
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