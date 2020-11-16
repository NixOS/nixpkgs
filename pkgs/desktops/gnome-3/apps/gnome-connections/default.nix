{ stdenv
, fetchurl
, gnome3
, meson
, ninja
, vala
, pkg-config
, glib
, gtk3
, python3
, libxml2
, gtk-vnc
, gettext
, desktop-file-utils
, appstream-glib
, gobject-introspection
, freerdp
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-connections";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/connections/${stdenv.lib.versions.majorMinor version}/connections-${version}.tar.xz";
    hash = "sha256-Eob36/zoWIGdYMpWks280FoIHGL7AHUhinFA4cEqels=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib # glib-compile-resources
    meson
    appstream-glib
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook

    # for gtk-frdp subproject
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk-vnc
    gtk3
    libxml2

    # for gtk-frdp subproject
    freerdp
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/connections";
    description = "A remote desktop client for the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
