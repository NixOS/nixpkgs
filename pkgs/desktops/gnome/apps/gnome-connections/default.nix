{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala_0_56
, gettext
, itstool
, python3
, appstream-glib
, desktop-file-utils
, wrapGAppsHook
, glib
, gtk3
, libhandy
, libsecret
, libxml2
, gtk-vnc
, gtk-frdp
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-connections";
  version = "42.1.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-2ObnJ0EJHYkt/IQoH2JVUdBWjNSC1I21ik7bivoTd7Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala_0_56
    gettext
    itstool
    python3
    appstream-glib
    desktop-file-utils
    glib # glib-compile-resources
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk-vnc
    gtk3
    libhandy
    libsecret
    libxml2
    gtk-frdp
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/connections";
    description = "A remote desktop client for the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
