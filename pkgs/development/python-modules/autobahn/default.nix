{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  argon2-cffi,
  base58,
  cbor2,
  cffi,
  click,
  cryptography,
  ecdsa,
  eth-abi,
  eth-account,
  flatbuffers,
  jinja2,
  hkdf,
  hyperlink,
  mnemonic,
  mock,
  msgpack,
  passlib,
  py-ecc,
  # , py-eth-sig-utils
  py-multihash,
  py-ubjson,
  pynacl,
  pygobject3,
  pyopenssl,
  qrcode,
  pytest-asyncio_0_21,
  python-snappy,
  pytestCheckHook,
  pythonOlder,
  # , pytrie
  rlp,
  service-identity,
  setuptools,
  spake2,
  twisted,
  txaio,
  ujson,
  # , web3
  # , wsaccel
  # , xbr
  yapf,
  # , zlmdb
  zope-interface,
}@args:

buildPythonPackage rec {
  pname = "autobahn";
  version = "23.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7JQhxSohAzZNHvBGgDbmAZ7oT3FyHoazb+Ga1pZsEYE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest>=2.8.6,<3.3.0" "pytest"
  '';

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    hyperlink
    pynacl
    txaio
  ];

  nativeCheckInputs =
    [
      mock
      pytest-asyncio_0_21
      pytestCheckHook
    ]
    ++ optional-dependencies.scram ++ optional-dependencies.serialization ++ optional-dependencies.xbr;

  preCheck = ''
    # Run asyncio tests (requires twisted)
    export USE_ASYNCIO=1
  '';

  pytestFlagsArray = [ "--pyargs autobahn" ];

  pythonImportsCheck = [ "autobahn" ];

  optional-dependencies = rec {
    all = accelerate ++ compress ++ encryption ++ nvx ++ serialization ++ scram ++ twisted ++ ui ++ xbr;
    accelerate = [
      # wsaccel
    ];
    compress = [ python-snappy ];
    encryption = [
      pynacl
      pyopenssl
      qrcode # pytrie
      service-identity
    ];
    nvx = [ cffi ];
    scram = [
      argon2-cffi
      cffi
      passlib
    ];
    serialization = [
      cbor2
      flatbuffers
      msgpack
      ujson
      py-ubjson
    ];
    twisted = [
      attrs
      args.twisted
      zope-interface
    ];
    ui = [ pygobject3 ];
    xbr = [
      base58
      cbor2
      click
      ecdsa
      eth-abi
      jinja2
      hkdf
      mnemonic
      py-ecc # py-eth-sig-utils
      py-multihash
      rlp
      spake2
      twisted # web3 xbr
      yapf # zlmdb
    ];
  };

  meta = with lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = [ ];
  };
}
