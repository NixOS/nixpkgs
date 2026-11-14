{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs_22,
  pkg-config,
  wrapGAppsHook4,
  gtk3,
  webkitgtk_4_1,
  libsoup_3,
  glib-networking,
  libayatana-appindicator,
  libnotify,
  librsvg,
  openssl,
  xdotool,
  git,
  xdg-utils,
  desktop-file-utils,
  which,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tolaria";
  version = "2026-11-10";

  src = fetchFromGitHub {
    owner = "refactoringhq";
    repo = "tolaria";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WJRzXywJ7s2IlQjCbJ2n278foHBIOk0A8lJycLPM+rc=";
  };

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    cargoRoot = finalAttrs.cargoRoot;
    hash = "sha256-a3OzXLEPjE2hD/gPSHKdnPI5QdumzB2IQpdxZP6OpXo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-VhnsYiwy/ELs8oe9ejWki1ukSd84zHGcB+kUjmR0JpM=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    rustPlatform.cargoSetupHook
    pkg-config
    pnpmConfigHook
    pnpm_10
    nodejs_22
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gtk3
    libayatana-appindicator
    libnotify
    libsoup_3
    librsvg
    webkitgtk_4_1
    xdotool
    git
    nodejs_22
    xdg-utils
    desktop-file-utils
    which
  ];

  buildAndTestSubdir = "src-tauri";

  env = {
    NODE_OPTIONS = "--max-old-space-size=4096";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Skip the .sig updater artifacts.
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'

    # libappindicator-sys hardcodes the .so name; point it at the store.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/Tolaria.desktop \
      --replace-fail "Exec=tolaria" "Exec=$out/bin/tolaria"
  '';

  dontWrapGApps = true;

  strictDeps = true;
  __structuredAttrs = true;

  postFixup = ''
    wrapProgram $out/bin/tolaria \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          nodejs_22
          xdg-utils
          desktop-file-utils
          which
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop app to manage markdown knowledge bases";
    homepage = "https://tolaria.md";
    downloadPage = "https://github.com/refactoringhq/tolaria/releases";
    changelog = "https://github.com/refactoringhq/tolaria/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tolaria";
    maintainers = with lib.maintainers; [ Supermarcel10 ];
    platforms = lib.platforms.linux;
  };
})
