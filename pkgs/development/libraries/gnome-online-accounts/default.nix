{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, vala
, glib
, meson
, ninja
, libxslt
, gtk4
, enableBackend ? stdenv.isLinux
, json-glib
, libadwaita
, librest_1_0
, libxml2
, libsecret
, gtk-doc
, gobject-introspection
, gettext
, glib-networking
, libsoup_3
, docbook-xsl-nons
, docbook_xml_dtd_412
, gnome
, gcr_4
, libkrb5
, gvfs
, dbus
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "gnome-online-accounts";
  version = "3.49.4";

  outputs = [ "out" "dev" ] ++ lib.optionals enableBackend [ "man" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-online-accounts";
    rev = version;
    sha256 = "sha256-NsNvYNi+2GAqDkY7O1rOH63sKLd3pOTDiNxtIOahnBs=";
  };

  mesonFlags = [
    "-Dfedora=false" # not useful in NixOS or for NixOS users.
    "-Dgoabackend=${lib.boolToString enableBackend}"
    "-Dgtk_doc=${lib.boolToString enableBackend}"
    "-Dman=${lib.boolToString enableBackend}"
    "-Dwebdav=true"
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
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gcr_4
    glib
    glib-networking
    gtk4
    libadwaita
    gvfs # OwnCloud, Google Drive
    json-glib
    libkrb5
    librest_1_0
    libxml2
    libsecret
    libsoup_3
  ];

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      versionPolicy = "odd-unstable";
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeOnlineAccounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.unix;
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
  };
}
