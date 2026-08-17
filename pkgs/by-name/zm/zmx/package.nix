{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk,
  installShellFiles,
  writeShellScriptBin,
  zig_0_15,
  nix-update-script,
}:
let
  zig = zig_0_15;

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
  version = "0.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "neurosnap";
    repo = "zmx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OkXtVf/LdBrZL6FH9TGx+mIhUXt2eSugLxZyMd+HL6k=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-TwKoeaE4g5G7t7smKoqHkCCh998nSqKx5k6sO2vDlGs=";
  };

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/zmx completions bash) \
      --zsh <($out/bin/zmx completions zsh) \
      --fish <($out/bin/zmx completions fish)
  '';

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
    ];
    mainProgram = "zmx";
    platforms = lib.platforms.unix;
  };
})
