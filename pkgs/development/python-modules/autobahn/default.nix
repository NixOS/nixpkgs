{ lib
, argon2_cffi
, buildPythonPackage
, cbor
, cbor2
, cffi
, cryptography
, fetchPypi
, flatbuffers
, mock
, msgpack
, passlib
, pynacl
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, twisted
, py-ubjson
, txaio
, ujson
, zope_interface
}:

buildPythonPackage rec {
  pname = "autobahn";
  version = "22.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YOH0xgKqzQUv/j1GrkC2t1+ChrPEaSLCE7UjFi5YwX4=";
  };

  propagatedBuildInputs = [
    argon2_cffi
    cbor
    cbor2
    cffi
    cryptography
    flatbuffers
    msgpack
    passlib
    py-ubjson
    pynacl
    twisted
    txaio
    ujson
    zope_interface
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest>=2.8.6,<3.3.0" "pytest"
  '';

  preCheck = ''
    # Run asyncio tests (requires twisted)
    export USE_ASYNCIO=1
  '';

  pytestFlagsArray = [
    "--pyargs autobahn"
  ];

  pythonImportsCheck = [
    "autobahn"
  ];

  meta = with lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
