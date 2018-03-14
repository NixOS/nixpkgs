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
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "281a9fa56b5ce587a2147ec285d18a224942f7e020581afa6cc44d7caecf937b";
  };

  disabled = pythonOlder "3.4";

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
