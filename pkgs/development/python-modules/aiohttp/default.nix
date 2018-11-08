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
, async_generator
, pytestrunner
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ykm6kdjkrg556j0zd7dx2l1rsrbh0d9g27ivr6dmaahz9pyrbsi";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest gunicorn pytest-mock async_generator pytestrunner pytest-timeout ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optional (pythonOlder "3.7") idna-ssl;


  # Several test failures. Need to be looked into.
  doCheck = false;

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
