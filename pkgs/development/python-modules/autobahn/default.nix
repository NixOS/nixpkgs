{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, attrs
, argon2-cffi
, base58
, cbor2
, cffi
, click
, cryptography
, ecdsa
, eth-abi
, eth-account
, flatbuffers
, jinja2
, hkdf
, hyperlink
, mnemonic
, mock
, msgpack
, passlib
, py-ecc
, py-eth-sig-utils
, py-multihash
, py-ubjson
, pynacl
, pygobject3
, pyopenssl
, qrcode
, pytest-asyncio
, python-snappy
, pytestCheckHook
, pythonOlder
  # , pytrie
, rlp
, service-identity
, spake2
, twisted
, txaio
, ujson
  # , web3
  # , wsaccel
  # , xbr
, yapf
  # , zlmdb
, zope_interface
}@args:

buildPythonPackage rec {
  pname = "autobahn";
  version = "22.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  patches = [
    (fetchpatch {
      # https://github.com/crossbario/autobahn-python/pull/1604
      url = "https://github.com/crossbario/autobahn-python/commit/ffe679fae4ebcdde964d4ee88cb82a9c65c40529.patch";
      sha256 = "sha256-QNnQkxMZJsFbiYUp4Os+dWo7jdCa96+kyb/2HxSMU8k=";
    })
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i0Yuouaq1rTcDtRfuAC2y/6wMl5/5pg5B/Ei8r5KH+k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest>=2.8.6,<3.3.0" "pytest"
  '';

  propagatedBuildInputs = [
    cryptography
    hyperlink
    pynacl
    txaio
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.scram
  ++ passthru.optional-dependencies.serialization
  ++ passthru.optional-dependencies.xbr;

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

  passthru.optional-dependencies = rec {
    all = accelerate ++ compress ++ encryption ++ nvx ++ serialization ++ scram ++ twisted ++ ui ++ xbr;
    accelerate = [ /* wsaccel */ ];
    compress = [ python-snappy ];
    encryption = [ pynacl pyopenssl qrcode /* pytrie */ service-identity ];
    nvx = [ cffi ];
    scram = [ argon2-cffi cffi passlib ];
    serialization = [ cbor2 flatbuffers msgpack ujson py-ubjson ];
    twisted = [ attrs args.twisted zope_interface ];
    ui = [ pygobject3 ];
    xbr = [ base58 cbor2 click ecdsa eth-abi jinja2 hkdf mnemonic py-ecc py-eth-sig-utils py-multihash rlp spake2 twisted /* web3 xbr */ yapf /* zlmdb */ ];
  };

  meta = with lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
