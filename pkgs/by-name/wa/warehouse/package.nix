{
  lib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  flatpak,
  flatpak-xdg-utils,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "warehouse";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "flattool";
    repo = "warehouse";
    tag = finalAttrs.version;
    hash = "sha256-3xtC6pcZo6MTypeILy+cNMBaPK+PlshIXaeJW6KGyV0=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    flatpak
    flatpak-xdg-utils
    glib
    gtk4
    libadwaita
    (python3.withPackages (
      ps: with ps; [
        pygobject3
      ]
    ))
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --suffix PATH : "${lib.makeBinPath [ flatpak-xdg-utils ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/flattool/warehouse/releases/tag/${finalAttrs.version}";
    description = "Manage all things Flatpak";
    homepage = "https://github.com/flattool/warehouse";
    license = lib.licenses.gpl3Plus;
    mainProgram = "warehouse";
    maintainers = with lib.maintainers; [ michaelgrahamevans ];
    platforms = lib.platforms.linux;
  };
})
