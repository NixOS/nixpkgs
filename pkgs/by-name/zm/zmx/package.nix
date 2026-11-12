{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk,
  installShellFiles,
  writeShellScriptBin,
  zig_0_17,
  nix-update-script,
  bashInteractive,
  bats,
  python3,
  unixtools,
  versionCheckHook,
}:
let
  zig = zig_0_17;

  sdkRoot = apple-sdk.sdkroot;
  # Ghostty's Zig build asks Zig to discover the native Darwin SDK via
  # std.zig.LibCInstallation.findNative, which shells out to xcrun/xcode-select
  # on macOS. Provide wrappers so this works inside the Nix sandbox.
  xcrunWrapper = writeShellScriptBin "xcrun" ''
    echo "${sdkRoot}"
  '';
  xcodeselectWrapper = writeShellScriptBin "xcode-select" ''
    echo "${sdkRoot}"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zmx";
  version = "1.0.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "neurosnap";
    repo = "zmx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aud/azC9TpnKs4jJrXBWO0LXWUFgu7u6Gg2z9jgc79g=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-3nLzn3Ara/7tZwcmWTnbEGnddfqz5kWTz+GLP36scwo=";
  };

  # `zmx write` drops chunks of large files on Darwin: https://github.com/neurosnap/zmx/issues/309
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace test/session.bats --replace-fail \
      '@test "write: a file larger than the PTY input buffer arrives whole" {' \
      '@test "write: a file larger than the PTY input buffer arrives whole" { skip "broken on Darwin"'
  '';

  # zmx needs a writable state directory, including for `zmx completions`
  preConfigure = ''
    export ZMX_DIR="$TMPDIR/zmx"
  '';

  postConfigure = ''
    # Zig may write cache metadata next to fetched dependencies while checking them.
    cp -rLT ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    installShellFiles
    zig
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcrunWrapper
    xcodeselectWrapper
  ];

  doCheck = true;

  nativeCheckInputs = [
    # only needed for postCheck
    bashInteractive
    bats
    python3
    unixtools.hostname
  ];

  postCheck = ''
    bats test
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/zmx completions bash) \
      --zsh <($out/bin/zmx completions zsh) \
      --fish <($out/bin/zmx completions fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/neurosnap/zmx";
    description = "Session persistence for terminal processes";
    longDescription = ''
      zmx provides session persistence for terminal shell sessions (pty processes).
      Features include ability to attach and detach from shell sessions without killing them,
      native terminal scrollback, multiple client connections to the same session,
      and restoration of previous terminal state and output when re-attaching.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dwt
      GabrielDougherty
      baptiste0928
    ];
    mainProgram = "zmx";
    platforms = lib.platforms.unix;
  };
})
