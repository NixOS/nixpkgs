{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,

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
  pytest-twisted,

  gitUpdater,
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole";
    tag = version;
    hash = "sha256-5Tipcood5RktXY05p20hQpWhSMMnZm67I4iybjV8TcA=";
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

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs =
    [
      magic-wormhole-mailbox-server
      magic-wormhole-transit-relay
      pytestCheckHook
      pytest-twisted
    ]
    ++ optional-dependencies.dilation
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unixtools.locale ];

  pytestFlagsArray = [ "src/wormhole/test" ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    install -Dm644 docs/wormhole.1 $out/share/man/man1/wormhole.1
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash wormhole_complete.bash \
      --fish wormhole_complete.fish \
      --zsh wormhole_complete.zsh
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://github.com/magic-wormhole/magic-wormhole/blob/${version}/NEWS.md";
    description = "Securely transfer data between computers";
    homepage = "https://magic-wormhole.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
    mainProgram = "wormhole";
  };
}
