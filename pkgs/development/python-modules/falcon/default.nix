{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
, aiofiles
, cbor2
, ddt
, gunicorn
, httpx
, hypercorn
, jsonschema
, msgpack
, mujson
, nose
, orjson
, pecan
, pytest-asyncio
, python-mimeparse
, pyyaml
, rapidjson
, requests
, testtools
, ujson
, uvicorn
, websockets
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "3.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8nYL0YwWOTpvteVfNx9nkh7bcv6+aTqCs8XoIZXQh7c=";
  };

  checkInputs = [
    aiofiles
    cbor2
    ddt
    gunicorn
    httpx
    hypercorn
    jsonschema
    msgpack
    mujson
    nose
    orjson
    pecan
    pytest-asyncio
    pytestCheckHook
    python-mimeparse
    pyyaml
    rapidjson
    requests
    testtools
    ujson
    uvicorn
    websockets
  ];

  disabledTestPaths = [
    # missing optional nuts package
    "falcon/bench/nuts/nuts/tests/test_functional.py"
  ];

  meta = with lib; {
    description = "An unladen web framework for building APIs and app backends";
    homepage = "https://falconframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };

}
