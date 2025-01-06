{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  magic-wormhole-transit-relay,
  magic-wormhole-mailbox-server,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole";
    tag = version;
    hash = "sha256-BxPF4iQ91wLBagdvQ/Y89VIZBkMxFiEHnK+BU55Bwr4=";
  };

  patches = [
    # TODO: drop patch for magic-wormhole > 0.17.0
    # fix test for twisted 24.10.0 (https://github.com/magic-wormhole/magic-wormhole/pull/554)
    (fetchpatch {
      name = "fix-twisted-24.10.0.patch";
      url = "https://github.com/magic-wormhole/magic-wormhole/commit/d7353cad6fe9d43620a0de33a634f395757d2e5c.patch";
      hash = "sha256-mvgVFW3Fa2I8/39ron0bYYsJNm2r97jnLFCfhtHSIP0=";
    })
  ];
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

  dependencies =
    [
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
