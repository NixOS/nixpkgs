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
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc5cab081d4b334d0440b019edf24fe1cb138b8114e0e22d2b0661284bc1775f";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest gunicorn pytest-mock async_generator ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optional (pythonOlder "3.7") idna-ssl;

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
