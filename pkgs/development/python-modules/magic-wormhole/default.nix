{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

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

let
  # magic-wormhole relies on the internal API of
  # magic-wormhole-transit-relay < 0.3.0 for testing.
  magic-wormhole-transit-relay_0_2_1 =
    magic-wormhole-transit-relay.overridePythonAttrs
      (oldAttrs: rec {
        version = "0.2.1";

        src = fetchPypi {
          pname = "magic-wormhole-transit-relay";
          inherit version;
          hash = "sha256-y0gBtGiQ6v+XKG4OP+xi0dUv/jF9FACDtjNqH7To+l4=";
        };

        postPatch = "";

        postCheck = "";

        meta.broken = pythonAtLeast "3.12";
      });
in
buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FObBRomNvaem0ZAmJiOmlBmVU2Pn5DTWSq0tIz1tlMk=";
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

  optional-dependencies = {
    dilation = [ noiseprotocol ];
  };

  nativeCheckInputs =
    # For Python 3.12, remove magic-wormhole-mailbox-server and magic-wormhole-transit-relay from test dependencies,
    # which are not yet supported with this version.
    lib.optionals
      (!magic-wormhole-mailbox-server.meta.broken && !magic-wormhole-transit-relay_0_2_1.meta.broken)
      [
        magic-wormhole-mailbox-server
        magic-wormhole-transit-relay_0_2_1
      ]
    ++ [
      mock
      pytestCheckHook
    ]
    ++ optional-dependencies.dilation
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unixtools.locale ];

  __darwinAllowLocalNetworking = true;

  disabledTestPaths =
    # For Python 3.12, remove the tests depending on magic-wormhole-mailbox-server and magic-wormhole-transit-relay,
    # which are not yet supported with this version.
    lib.optionals
      (magic-wormhole-mailbox-server.meta.broken || magic-wormhole-transit-relay_0_2_1.meta.broken)
      [
        "src/wormhole/test/dilate/test_full.py"
        "src/wormhole/test/test_args.py"
        "src/wormhole/test/test_cli.py"
        "src/wormhole/test/test_transit.py"
        "src/wormhole/test/test_wormhole.py"
        "src/wormhole/test/test_xfer_util.py"
      ];

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
