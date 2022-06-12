{ lib, stdenv
, fetchFromGitLab
, pkg-config
, vala
, glib
, meson
, ninja
, python3
, libxslt
, gtk3
, webkitgtk
, json-glib
, librest
, libsecret
, gtk-doc
, gobject-introspection
, gettext
, icu
, glib-networking
, libsoup
, docbook-xsl-nons
, docbook_xml_dtd_412
, gnome
, gcr
, libkrb5
, gvfs
, dbus
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-online-accounts";
  version = "3.44.0";

  # https://gitlab.gnome.org/GNOME/gnome-online-accounts/issues/87
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-online-accounts";
    rev = version;
    sha256 = "sha256-8dp3cizyQVHegDxX9G6iGLW5g44audn431hCPMS/KlA=";
  };

  outputs = [ "out" "man" "dev" "devdoc" ];

  mesonFlags = [
    "-Dfedora=false" # not useful in NixOS or for NixOS users.
    "-Dgtk_doc=true"
    "-Dman=true"
    "-Dmedia_server=true"
  ];

  nativeBuildInputs = [
    dbus # used for checks and pkg-config to install dbus service/s
    docbook_xml_dtd_412
    docbook-xsl-nons
    gettext
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gcr
    glib
    glib-networking
    gtk3
    gvfs # OwnCloud, Google Drive
    icu
    json-glib
    libkrb5
    librest
    libsecret
    libsoup
    webkitgtk
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      versionPolicy = "odd-unstable";
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeOnlineAccounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
  };
}
