{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs_22,
  npmHooks,
  pkg-config,
  patchelf,
  openssl,
  wrapGAppsHook4,
  clang,
  llvmPackages,
  webkitgtk_4_1,
  gtk3,
  cairo,
  gdk-pixbuf,
  glib,
  dbus,
  libsoup_3,
  librsvg,
  pango,
  harfbuzz,
  at-spi2-atk,
  glib-networking,
  gsettings-desktop-schemas,
  krb5,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminus";
  version = "0.1.0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "delikesance";
    repo = "terminus";
    rev = "81308ba1819355360ba24cc76d5730318381b0da";
    hash = "sha256-KdF6e4bLn3ETnxa77T7kM3Piea7ZWX252oisqP2edg0=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-Jc1sn/o4fk6LMO36fCTTdiNH1GCtXV6Mg2jep0xNYqg=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_22
    npmHooks.npmConfigHook
    pkg-config
    patchelf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
    clang
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    libsoup_3
    librsvg
    pango
    harfbuzz
    at-spi2-atk
    glib-networking
    gsettings-desktop-schemas
    krb5
    llvmPackages.libclang
  ];

  buildAndTestSubdir = "src-tauri";
  tauriBundleType = "deb";

  LIBCLANG_PATH = lib.optionalString stdenv.hostPlatform.isLinux "${llvmPackages.libclang.lib}/lib";

  doCheck = false;

  meta = {
    description = "Open-source Termius alternative — SSH/SFTP terminal";
    homepage = "https://github.com/delikesance/terminus";
    changelog = "https://github.com/delikesance/terminus/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "terminus";
    platforms = lib.platforms.linux;
  };
})
