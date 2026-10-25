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
  humanity-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yaru";
  version = "26.10.3";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    tag = finalAttrs.version;
    hash = "sha256-E8CYl0i9/UzlwhnmBl8IDDeAoB9AxOWAbOnPm2HOcz0=";
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
    hicolor-icon-theme # its setup hook symlinks inherited parent icon themes
  ];
  propagatedBuildInputs = [
    humanity-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = "patchShebangs .";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ubuntu community theme 'yaru' - default Ubuntu theme since 18.10";
    homepage = "https://github.com/ubuntu/yaru";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3Plus
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mershl
      moni
    ];
  };
})
