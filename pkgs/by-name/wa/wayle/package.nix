{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  fftw,
  glib,
  gtk4-layer-shell,
  gtksourceview5,
  installShellFiles,
  libpulseaudio,
  libxkbcommon,
  makeDesktopItem,
  nix-update-script,
  pipewire,
  pixman,
  pkg-config,
  rustPlatform,
  stdenv,
  udev,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayle";
  version = "0.2.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wayle-rs";
    repo = "wayle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K4ItGV7kTZrm3uqHeN/hSZjKzkQpSn+nan3509FYUQw=";
  };

  cargoHash = "sha256-omCcKXYouS9qPdhVINJC2mAjI7uG0M9MH14BN/4Zegs=";

  nativeBuildInputs = [
    copyDesktopItems
    glib
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4-layer-shell.dev
    gtksourceview5
    # Not sure why ".dev" is needed here, but CMake doesn't find libxkbcommon otherwise
    libxkbcommon.dev
    pixman
    udev

    # for generating libcava bindings
    fftw.dev
    libpulseaudio
    pipewire.dev
  ];

  cargoBuildFlags = [
    "--bin=wayle"
    "--bin=wayle-settings"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # GTK4 failed to initialize (requires GUI?)
    "--skip=tests::css_loads_into_gtk4"
  ];

  preInstall = ''
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp -r resources/icons "$out/share"
    cp resources/wayle-settings.svg "$out/share/icons/hicolor/scalable/apps"
  '';

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      # bash
      ''
        installShellCompletion --cmd wayle \
          --bash <($out/bin/wayle completions bash) \
          --fish <($out/bin/wayle completions fish) \
          --zsh <($out/bin/wayle completions zsh)
      '';

  preFixup = ''
    # so wayle could access wayle-settings binary
    gappsWrapperArgs+=( --suffix PATH : $out/bin )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.wayle.settings.desktop";
      type = "Application";
      desktopName = "Wayle Settings";
      genericName = "Shell Settings";
      comment = "Configure the Wayle desktop shell";
      exec = "wayle-settings";
      icon = "wayle-settings";
      terminal = false;
      categories = [
        "Settings"
        "DesktopSettings"
        "GTK"
      ];
      keywords = [
        "wayle"
        "settings"
        "shell"
        "bar"
        "wayland"
        "config"
      ];
      startupNotify = true;
      startupWMClass = "com.wayle.settings";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland Elements - A compositor agnostic shell with extensive customization";
    homepage = "https://github.com/wayle-rs/wayle/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "wayle";
    platforms = lib.platforms.linux;
  };
})
