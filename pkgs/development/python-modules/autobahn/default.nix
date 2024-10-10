{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  pytest-asyncio,
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
  version = "24.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "crossbario";
    repo = "autobahn-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-aeTE4a37zr83KZ+v947XikzFrHAhkZ4mj4tXdkQnB84=";
  };

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
      pytest-asyncio
      pytestCheckHook
    ]
    ++ optional-dependencies.scram ++ optional-dependencies.serialization ++ optional-dependencies.xbr;

  preCheck = ''
    # Run asyncio tests (requires twisted)
    export USE_ASYNCIO=1
  '';

  pytestFlagsArray = [
    "--ignore=./autobahn/twisted"
    "./autobahn"
  ];

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
    changelog = "https://github.com/crossbario/autobahn-python/blob/${src.rev}/docs/changelog.rst";
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = [ ];
  };
}
