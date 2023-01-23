{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, vala
, glib
, meson
, ninja
, libxslt
, gtk3
, enableBackend ? stdenv.isLinux
, webkitgtk_4_1
, json-glib
, librest_1_0
, libxml2
, libsecret
, gtk-doc
, gobject-introspection
, gettext
, icu
, glib-networking
, libsoup_3
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
  version = "3.46.0";

  outputs = [ "out" "dev" ] ++ lib.optionals enableBackend [ "man" "devdoc" ];

  # https://gitlab.gnome.org/GNOME/gnome-online-accounts/issues/87
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-online-accounts";
    rev = version;
    sha256 = "sha256-qVd55fmhY05zJ871OWc3hd1eWjYbYJuxlE/T2i3VCUA=";
  };

  mesonFlags = [
    "-Dfedora=false" # not useful in NixOS or for NixOS users.
    "-Dgoabackend=${lib.boolToString enableBackend}"
    "-Dgtk_doc=${lib.boolToString enableBackend}"
    "-Dman=${lib.boolToString enableBackend}"
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
    librest_1_0
    libxml2
    libsecret
    libsoup_3
  ] ++ lib.optionals enableBackend [
    webkitgtk_4_1
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

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
