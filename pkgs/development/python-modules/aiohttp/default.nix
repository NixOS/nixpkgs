{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
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
  version = "2.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964";
  };

  disabled = pythonOlder "3.4";

  checkInputs = [ pytest gunicorn pytest-mock ];

  propagatedBuildInputs = [ async-timeout chardet multidict yarl ]
    ++ lib.optional (pythonOlder "3.7") idna-ssl;

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/KeepSafe/aiohttp/;
    maintainers = with maintainers; [ dotlambda ];
  };
}
