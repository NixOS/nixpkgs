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
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f20deec7a3fbaec7b5eb7ad99878427ad2ee4cc16a46732b705e8121cbb3cc12";
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
