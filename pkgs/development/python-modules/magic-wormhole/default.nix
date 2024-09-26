{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  spake2,
  pynacl,
  six,
  attrs,
  twisted,
  autobahn,
  automat,
  tqdm,
  click,
  humanize,
  iterable-io,
  txtorcon,
  zipstream-ng,

  # optional-dependencies
  noiseprotocol,

  # tests
  nettools,
  unixtools,
  mock,
  magic-wormhole-transit-relay,
  magic-wormhole-mailbox-server,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-viVjtcVUe6MzvGYI8EgATI821VYTm/L/49n0HaJ5cAY=";
  };

  postPatch =
    # enable tests by fixing the location of the wormhole binary
    ''
      substituteInPlace src/wormhole/test/test_cli.py --replace-fail \
        'locations = procutils.which("wormhole")' \
        'return "${placeholder "out"}/bin/wormhole"'
    ''
    # fix the location of the ifconfig binary
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
    '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "spake2"
  ];

  dependencies = [
    attrs
    autobahn
    automat
    click
    humanize
    iterable-io
    pynacl
    six
    spake2
    tqdm
    twisted
    txtorcon
    zipstream-ng
  ] ++ autobahn.optional-dependencies.twisted ++ twisted.optional-dependencies.tls;

  passthru.optional-dependencies = {
    dilation = [ noiseprotocol ];
  };

  nativeCheckInputs =
    # For Python 3.12, remove magic-wormhole-mailbox-server and magic-wormhole-transit-relay from test dependencies,
    # which are not yet supported with this version.
    lib.optionals (!magic-wormhole-mailbox-server.meta.broken) [ magic-wormhole-mailbox-server ]
    ++ lib.optionals (!magic-wormhole-transit-relay.meta.broken) [ magic-wormhole-transit-relay ]
    ++ [
      mock
      pytestCheckHook
    ]
    ++ passthru.optional-dependencies.dilation
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unixtools.locale ];

  __darwinAllowLocalNetworking = true;

  disabledTestPaths =
    # For Python 3.12, remove the tests depending on magic-wormhole-mailbox-server and magic-wormhole-transit-relay,
    # which are not yet supported with this version.
    lib.optionals
      (magic-wormhole-mailbox-server.meta.broken || magic-wormhole-transit-relay.meta.broken)
      [
        "src/wormhole/test/dilate/test_full.py"
        "src/wormhole/test/test_args.py"
        "src/wormhole/test/test_cli.py"
        "src/wormhole/test/test_wormhole.py"
        "src/wormhole/test/test_xfer_util.py"
      ]
    ++ lib.optionals magic-wormhole-transit-relay.meta.broken [ "src/wormhole/test/test_transit.py" ];

  postInstall = ''
    install -Dm644 docs/wormhole.1 $out/share/man/man1/wormhole.1
  '';

  meta = {
    changelog = "https://github.com/magic-wormhole/magic-wormhole/blob/${version}/NEWS.md";
    description = "Securely transfer data between computers";
    homepage = "https://github.com/magic-wormhole/magic-wormhole";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
    mainProgram = "wormhole";
  };
}
