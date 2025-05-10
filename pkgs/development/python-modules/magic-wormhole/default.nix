{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

  # dependencies
  attrs,
  autobahn,
  automat,
  click,
  cryptography,
  humanize,
  iterable-io,
  pynacl,
  qrcode,
  spake2,
  tqdm,
  twisted,
  txtorcon,
  zipstream-ng,

  # optional-dependencies
  noiseprotocol,

  # tests
  nettools,
  unixtools,
  magic-wormhole-transit-relay,
  magic-wormhole-mailbox-server,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole";
    tag = version;
    hash = "sha256-FQ7m6hkJcFZaE+ptDALq/gijn/RcAM1Zvzi2+xpoXBU=";
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

  build-system = [
    setuptools
    versioneer
  ];

  dependencies =
    [
      attrs
      autobahn
      automat
      click
      cryptography
      humanize
      iterable-io
      pynacl
      qrcode
      spake2
      tqdm
      twisted
      txtorcon
      zipstream-ng
    ]
    ++ autobahn.optional-dependencies.twisted
    ++ twisted.optional-dependencies.tls;

  optional-dependencies = {
    dilation = [ noiseprotocol ];
  };

  nativeCheckInputs =
    [
      magic-wormhole-mailbox-server
      magic-wormhole-transit-relay
      pytestCheckHook
    ]
    ++ optional-dependencies.dilation
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unixtools.locale ];

  __darwinAllowLocalNetworking = true;

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
