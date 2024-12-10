{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnome,
  gtk4,
  wrapGAppsHook4,
  librsvg,
  gsound,
  gettext,
  itstool,
  vala,
  libxml2,
  libgee,
  libgnome-games-support_2_0,
  meson,
  ninja,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-nibbles";
  version = "4.0.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor finalAttrs.version}/gnome-nibbles-${finalAttrs.version}.tar.xz";
    hash = "sha256-1xKkxpQ78ylWrfuSIvHxQ2mRHlTs67DNYffCWr16Wdo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    librsvg
    gsound
    libgee
    libgnome-games-support_2_0
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome.gnome-nibbles";
    };
  };

  meta = with lib; {
    description = "Guide a worm around a maze";
    mainProgram = "gnome-nibbles";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-nibbles";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
