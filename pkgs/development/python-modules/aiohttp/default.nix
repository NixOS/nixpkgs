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
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb873da531401416acb7045a8f0bdf6555e9c6866989cd977166fae3cbbb954b";
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
