{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xdg-terminal-exec,
  gtk3,
  gdk-pixbuf,
  cairo,
  pango,
  glib,
  atk,
  libappindicator,
  libdbusmenu-gtk3,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "walls";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "willfish";
    repo = "walls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6c4NdXGPsDFqlLLMH2BL0MpoQpZiLxJnWMzWKN1bO84=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-WZK3QkeBqDkH/5m9mqhyJQDKZoA6LfEuFbMRImJN4oQ=";

  cargoBuildFlags = [
    "-p"
    "walls"
    "-p"
    "walls-tray"
  ];

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    gdk-pixbuf
    cairo
    pango
    glib
    atk
    libappindicator
    libdbusmenu-gtk3
  ];

  # PTY integration test is unreliable in the Nix build sandbox.
  cargoTestFlags = [
    "--workspace"
    "--"
    "--skip"
    "tui_with_pty_exits_cleanly_on_quit"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons/hicolor/scalable/apps $out/share/applications
    cp assets/icons/walls-tray.svg $out/share/icons/hicolor/scalable/apps/walls.svg
    substitute assets/applications/walls.desktop.in $out/share/applications/walls.desktop \
      --replace-fail '@walls@' "$out/bin/walls" \
      --replace-fail '@xdg-terminal-exec@' "${lib.getExe xdg-terminal-exec}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wallpaper manager with Wallhaven sources, CLI/TUI, and tray";
    homepage = "https://github.com/willfish/walls";
    changelog = "https://github.com/willfish/walls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ willfish ];
    mainProgram = "walls";
    # Upstream CI builds the flake package on x86_64/aarch64 Linux and Darwin
    # (tray GTK deps are Linux-only; Darwin still produces walls + walls-tray).
    # x86_64-darwin is dropped in nixpkgs 26.11; platforms.darwin is aarch64-only there.
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
