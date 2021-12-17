{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, fontconfig
, glib
, gsettings-desktop-schemas
, gtk4
, libadwaita
, xdg-desktop-portal
, wayland
, gnome
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gnome";
  version = "41.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "u6FEGZ5+1LlJCyScGvZFqGnWKZMmXerDjyGb8EL//fI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fontconfig
    glib
    gsettings-desktop-schemas # settings exposed by settings portal
    gtk4
    libadwaita
    xdg-desktop-portal
    wayland # required by GTK 4
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for the GNOME desktop environment";
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
