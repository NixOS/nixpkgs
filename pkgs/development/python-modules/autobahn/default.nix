{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  pytest-asyncio_0,
  python-snappy,
  pytestCheckHook,
  pythonOlder,
  service-identity,
  setuptools,
  twisted,
  txaio,
  ujson,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "autobahn";
  version = "24.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crossbario";
    repo = "autobahn-python";
    tag = "v${version}";
    hash = "sha256-aeTE4a37zr83KZ+v947XikzFrHAhkZ4mj4tXdkQnB84=";
  };

  patches = [
    (fetchpatch2 {
      # removal of broken pytest-asyncio markers
      url = "https://github.com/crossbario/autobahn-python/commit/7bc85b34e200640ab98a41cfddb38267f39bc92e.patch";
      hash = "sha256-JbuYWQhvjlXuHde8Z3ZSJAyrMOdIcE1GOq+Eh2HTz8c=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    hyperlink
    pynacl
    txaio
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio_0
    pytestCheckHook
  ]
  ++ optional-dependencies.scram
  ++ optional-dependencies.serialization;

  preCheck = ''
    # Run asyncio tests (requires twisted)
    export USE_ASYNCIO=1
  '';

  enabledTestPaths = [
    "./autobahn"
  ];

  disabledTestPaths = [
    "./autobahn/twisted"
  ];

  pythonImportsCheck = [ "autobahn" ];

  optional-dependencies = lib.fix (self: {
    all =
      self.accelerate
      ++ self.compress
      ++ self.encryption
      ++ self.nvx
      ++ self.serialization
      ++ self.scram
      ++ self.twisted
      ++ self.ui;
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
      twisted
      zope-interface
    ];
    ui = [ pygobject3 ];
  });

  meta = with lib; {
    changelog = "https://github.com/crossbario/autobahn-python/blob/${src.rev}/docs/changelog.rst";
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    license = licenses.mit;
    maintainers = [ ];
  };
}
