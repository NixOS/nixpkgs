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
  net-tools,
  unixtools,
  hypothesis,
  magic-wormhole-mailbox-server,
  magic-wormhole-transit-relay,
  pytestCheckHook,
  pytest-twisted,

  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "magic-wormhole";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole";
    tag = finalAttrs.version;
    # Work around irreproducible usage of export-subst by manually fixing $Format:%d$.
    postFetch = ''
      sed -Ei 's/^(\s+git_refnames = ").*"$/\1 (tag: ${finalAttrs.src.tag})"/' $out/src/wormhole/_version.py
      grep -Exq '\s+git_refnames = " \(tag: ${finalAttrs.src.tag}\)"' $out/src/wormhole/_version.py
    '';
    hash = "sha256-KOKxgruxHqIyyvfO3lkVrkBt7wVCTnxO4L/hSYCMuGY=";
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
      sed -i -e "s|'ifconfig'|'${net-tools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
    '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
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

  nativeCheckInputs = [
    hypothesis
    magic-wormhole-mailbox-server
    magic-wormhole-transit-relay
    pytestCheckHook
    pytest-twisted
  ]
  ++ finalAttrs.finalPackage.optional-dependencies.dilation
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ unixtools.locale ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installManPage docs/wormhole.1

    # https://github.com/magic-wormhole/magic-wormhole/issues/619
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash wormhole_complete.bash \
      --fish wormhole_complete.fish \
      --zsh wormhole_complete.zsh
    rm $out/share/*/*/wormhole_complete.*
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://github.com/magic-wormhole/magic-wormhole/blob/${finalAttrs.src.rev}/NEWS.md";
    description = "Securely transfer data between computers";
    homepage = "https://magic-wormhole.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mjoerg ];
    mainProgram = "wormhole";
  };
})
