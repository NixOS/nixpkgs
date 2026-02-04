{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  desktop-file-utils,
  gnome-desktop,
  meson,
  ninja,
  pkg-config,
  polkit,
  rustc,
  rustPlatform,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gtk4,
  libadwaita,
  openssl,
  nix-update-script,
  callPackage,
  parted,
  vte-gtk4,
  appstream-glib,
  gettext,
  git,
  gnome,
  libgweather,
  rust-analyzer,
  clippy,
}:

let
  convertyml = (callPackage ./convertyml/default.nix { });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "xeonitte";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "xinux-org";
    repo = "xeonitte";
    tag = finalAttrs.version;
    hash = "sha256-VY3WmsgCiVQyLo7DqjCq8A/GwRjAnImyedbaILgbNIw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8Cdg/xiaQnG3PGG5+XCgiCWrjEuGpzngt+KDiH/0A4I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib
    cargo
    rust-analyzer
    clippy
    convertyml
    desktop-file-utils
    gettext
    git
    meson
    ninja
    pkg-config
    polkit
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    polkit
    desktop-file-utils
    gdk-pixbuf
    glib
    gnome-desktop
    adwaita-icon-theme
    gtk4
    libadwaita
    libgweather
    openssl
    parted
    rustPlatform.bindgenHook
    vte-gtk4
  ];

  propagatedUserEnvPkgs = [ polkit ];

  postInstall = ''
    gappsWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/xinux-org/xeonitte";
    mainProgram = "Xeonitte";
    description = "A graphical installer for NixOS based distributions";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      orzklv
      shakhzodkudratov
      bahrom04
      bemeritus
    ];
  };
})
