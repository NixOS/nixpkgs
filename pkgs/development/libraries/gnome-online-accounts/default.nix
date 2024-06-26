{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  vala,
  glib,
  meson,
  ninja,
  libxslt,
  gtk4,
  enableBackend ? stdenv.isLinux,
  json-glib,
  libadwaita,
  librest_1_0,
  libxml2,
  libsecret,
  gtk-doc,
  gobject-introspection,
  gettext,
  glib-networking,
  libsoup_3,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  gnome,
  gcr_4,
  libkrb5,
  gvfs,
  dbus,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-online-accounts";
  version = "3.50.2";

  outputs =
    [
      "out"
      "dev"
    ]
    ++ lib.optionals enableBackend [
      "man"
      "devdoc"
    ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${lib.versions.majorMinor finalAttrs.version}/gnome-online-accounts-${finalAttrs.version}.tar.xz";
    hash = "sha256-3xatl10TnGv8TrsuyLuDJyl6eR7yvwuXfHgHavX6qY4=";
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
      packageName = "gnome-online-accounts";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-online-accounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.unix;
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
  };
})
