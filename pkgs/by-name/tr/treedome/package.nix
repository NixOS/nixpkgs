{
  lib,
  cargo-tauri,
  dbus,
  fetchgit,
  fetchYarnDeps,
  freetype,
  gsettings-desktop-schemas,
  yarnConfigHook,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  libayatana-appindicator,
  wrapGAppsHook4,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "treedome";
  version = "0.5.4";

  src = fetchgit {
    url = "https://codeberg.org/solver-orgz/treedome";
    rev = version;
    hash = "sha256-fJnrM9I11JKqzrprXa51mJiz9oO5hDp6u69FqJs5l8o=";
    fetchLFS = true;
  };

  cargoHash = "sha256-scCF4xpc1COdlg57/eNTPdgY7/cJkdcc2s1YNraXzXk=";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-in1A1XcfZK5F/EV5CYgfqig+8vKsxd6XhzfSv7Z0nNQ=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook4
    yarnConfigHook
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    webkitgtk_4_1
    libayatana-appindicator
    gsettings-desktop-schemas
    sqlite
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  env = {
    VERGEN_GIT_DESCRIBE = version;
  };

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup = ''
    wrapProgram "$out/bin/treedome" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = {
    description = "Local-first, encrypted, note taking application organized in tree-like structures";
    homepage = "https://codeberg.org/solver-orgz/treedome";
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "treedome";
    maintainers = with lib.maintainers; [ tengkuizdihar ];
    changelog = "https://codeberg.org/solver-orgz/treedome/releases/tag/${version}";
  };
}
