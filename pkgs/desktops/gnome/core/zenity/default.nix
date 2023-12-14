{ stdenv
, lib
, fetchurl
, help2man
, meson
, ninja
, pkg-config
, libxml2
, gnome
, gtk4
, gettext
, libadwaita
, itstool
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenity";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor finalAttrs.version}/zenity-${finalAttrs.version}.tar.xz";
    sha256 = "C4yN7xjasFzEm9RkuQyn+UWuUv9eCSQtpwKhXZTT6N0=";
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
      attrPath = "gnome.zenity";
    };
  };

  meta = with lib; {
    mainProgram = "zenity";
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://wiki.gnome.org/Projects/Zenity";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
})
