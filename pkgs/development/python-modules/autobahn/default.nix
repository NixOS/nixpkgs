{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  argon2-cffi,
  cbor2,
  cffi,
  cryptography,
  flatbuffers,
  hyperlink,
  mock,
  msgpack,
  passlib,
  py-ubjson,
  pynacl,
  pygobject3,
  pyopenssl,
  qrcode,
  pytest-asyncio,
  python-snappy,
  pytestCheckHook,
  pythonOlder,
  service-identity,
  setuptools,
  twisted,
  txaio,
  ujson,
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
    ++ optional-dependencies.scram
    ++ optional-dependencies.serialization;

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
    all = accelerate ++ compress ++ encryption ++ nvx ++ serialization ++ scram ++ twisted ++ ui;
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
  };

  meta = with lib; {
    changelog = "https://github.com/crossbario/autobahn-python/blob/${src.rev}/docs/changelog.rst";
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = [ ];
  };
}
