{ lib, buildPythonPackage, fetchPypi
, aiohttp, jsonrpc-base, pep8
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "jsonrpc-websocket";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c343d057b572791ed3107b771c17358bc710772a9a6156047a3cfafb409ed895";
  };

  nativeBuildInputs = [ pep8 ];

  propagatedBuildInputs = [ aiohttp jsonrpc-base ];

  checkInputs = [ pytestCheckHook pytest-asyncio ];
  pytestFlagsArray = [ "tests.py" ];

  meta = with lib; {
    description = "A JSON-RPC websocket client library for asyncio";
    homepage = "https://github.com/armills/jsonrpc-websocket";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
