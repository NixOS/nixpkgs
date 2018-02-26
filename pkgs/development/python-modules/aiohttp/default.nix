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
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a96be9189b2d51e366106e4207c9afaf3d69462562548a613e399c311ff70b88";
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
