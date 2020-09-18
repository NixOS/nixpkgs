{ stdenv
, meson
, ninja
, gettext
, fetchurl
, pkgconfig
, wrapGAppsHook
, itstool
, desktop-file-utils
, python3
, glib
, gtk3
, evolution-data-server
, gnome-online-accounts
, libuuid
, libhandy
, webkitgtk
, zeitgeist
, gnome3
, libxml2
, gsettings-desktop-schemas
, tracker
}:

stdenv.mkDerivation rec {
  pname = "gnome-notes";
  version = "3.37.90";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${stdenv.lib.versions.majorMinor version}/bijiben-${version}.tar.xz";
    sha256 = "0zy3gp24w0cd5nxwpz9s27cvpqsi9jn2y8dn3d771fin45hmhnr6";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    itstool
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libuuid
    libhandy
    webkitgtk
    tracker
    gnome-online-accounts
    zeitgeist
    gsettings-desktop-schemas
    evolution-data-server
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Dzeitgeist=true"
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "bijiben";
      attrPath = "gnome3.gnome-notes";
    };
  };

  meta = with stdenv.lib; {
    description = "Note editor designed to remain simple to use";
    homepage = "https://wiki.gnome.org/Apps/Notes";
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
