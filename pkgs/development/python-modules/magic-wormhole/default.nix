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
  version = "0.14.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AG0jn4i/98N7wu/2CgBOJj+vklj3J5GS0Gugyc7WsIA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs =
    [
      spake2
      pynacl
      six
      attrs
      twisted
      autobahn
      automat
      tqdm
      click
      humanize
      iterable-io
      txtorcon
      zipstream-ng
    ]
    ++ autobahn.optional-dependencies.twisted
    ++ twisted.optional-dependencies.tls;

  passthru.optional-dependencies = {
    dilation = [ noiseprotocol ];
  };

  nativeCheckInputs =
    [
      mock
      magic-wormhole-transit-relay
      magic-wormhole-mailbox-server
      pytestCheckHook
    ]
    ++ passthru.optional-dependencies.dilation
    ++ lib.optionals stdenv.isDarwin [ unixtools.locale ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # These tests doesn't work within Darwin's sandbox
    "test_version"
    "test_text"
    "test_receiver"
    "test_sender"
    "test_sender_allocation"
    "test_text_wrong_password"
    "test_override"
    "test_allocate_port"
    "test_allocate_port_no_reuseaddr"
    "test_ignore_localhost_hint"
    "test_ignore_localhost_hint_orig"
    "test_keep_only_localhost_hint"
    "test_get_direct_hints"
    "test_listener"
    "test_success_direct"
    "test_direct"
    "test_relay"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # These tests doesn't work within Darwin's sandbox
    "src/wormhole/test/test_xfer_util.py"
    "src/wormhole/test/test_wormhole.py"
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
  '';

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
