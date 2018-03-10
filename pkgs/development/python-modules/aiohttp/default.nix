{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, chardet
, multidict
, async-timeout
, yarl
, idna-ssl
, pytest
, gunicorn
, pytest-mock
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7aee5c0750584946fde40da70f0b28fe769f85182f1171acef18a35fd8ecd221";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest gunicorn pytest-mock ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optional (pythonOlder "3.7") idna-ssl;

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
