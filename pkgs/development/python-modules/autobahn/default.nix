{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cffi,
  hatchling,
  setuptools,

  # dependencies
  cryptography,
  hyperlink,
  pynacl,
  txaio,

  # optional-dependencies
  # compress
  python-snappy,
  # encryption
  base58,
  pyopenssl,
  qrcode,
  service-identity,
  # scram
  argon2-cffi,
  passlib,
  # serialization
  cbor2,
  flatbuffers,
  msgpack,
  ujson,
  py-ubjson,
  # twisted
  attrs,
  twisted,
  zope-interface,
  # ui
  pygobject3,

  # tests
  mock,
  pytest-asyncio_0,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "autobahn";
  version = "26.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crossbario";
    repo = "autobahn-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OepX1Hf2McNQhXPWfshU2SgLMzqz8AEbRm8ha1s//K8=";
  };

  build-system = [
    cffi
    hatchling
    setuptools
  ];

  dependencies = [
    cryptography
    hyperlink
    pynacl
    txaio
  ];

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
      base58
      # ecdsa (marked as insecure)
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

  pythonImportsCheck = [ "autobahn" ];

  nativeCheckInputs = [
    mock
    pytest-asyncio_0
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.encryption
  ++ finalAttrs.passthru.optional-dependencies.scram
  ++ finalAttrs.passthru.optional-dependencies.serialization;

  preCheck = ''
    # Run asyncio tests (requires twisted)
    export USE_ASYNCIO=1
    rm src/autobahn/__init__.py
  '';

  enabledTestPaths = [
    "src/autobahn"
  ];

  disabledTestPaths = [
    "src/autobahn/twisted"

    # Requires insecure ecdsa library
    "src/autobahn/wamp/test/test_wamp_cryptosign.py"
  ];

  disabledTests = [
    # Tests require insecure ecdsa library
    "test_crypto_extras_present"
    "test_import[autobahn.wamp.cryptosign]"
  ];

  meta = {
    description = "WebSocket and WAMP in Python for Twisted and asyncio";
    homepage = "https://crossbar.io/autobahn";
    downloadPage = "https://github.com/crossbario/autobahn-python";
    changelog = "https://github.com/crossbario/autobahn-python/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
