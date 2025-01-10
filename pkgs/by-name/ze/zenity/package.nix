{
  stdenv,
  lib,
  fetchurl,
  help2man,
  meson,
  ninja,
  pkg-config,
  libxml2,
  gnome,
  gtk4,
  gettext,
  libadwaita,
  itstool,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenity";
  version = "4.0.3";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor finalAttrs.version}/zenity-${finalAttrs.version}.tar.xz";
    hash = "sha256-tCnZe4e9nOf7cqwLeN9TRyXYrTmBfdympMou5TgbCN4=";
  };

  nativeBuildInputs = [
    help2man
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "zenity";
    };
  };

  meta = with lib; {
    mainProgram = "zenity";
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://gitlab.gnome.org/GNOME/zenity";
    changelog = "https://gitlab.gnome.org/GNOME/zenity/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
})
