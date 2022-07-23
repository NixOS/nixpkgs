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
, gnome-desktop
, xdg-desktop-portal
, wayland
, gnome
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gnome";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "8HeFvtoVI5E8tP9vjDOk49u4uW0uWYOVRexAGwguVHw=";
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
    gnome-desktop
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
    homepage = "https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome";
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
