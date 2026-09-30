{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  sassc,
  pkg-config,
  glib,
  ninja,
  python3,
  gtk3,
  nix-update-script,
  gnome,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yaru-remix";
  version = "40";

  src = fetchFromGitHub {
    owner = "Muqtxdir";
    repo = "yaru-remix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jADkbQ+RGgGIiNBG3dKnAh1uuAXy9R4B8l739QqHNHY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    sassc
    pkg-config
    glib
    ninja
    python3
    gtk3 # for gtk-update-icon-cache
  ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  # The GTK2 themes need an engine that is no longer packaged.
  # Remove once this tracks a yaru revision that dropped GTK2.
  patches = [ ./remove-gtk2.patch ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fork of the Yaru GTK theme";
    homepage = "https://github.com/Muqtxdir/yaru-remix";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3Plus
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ hoppla20 ];
  };
})
