{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, pkg-config
, vala
, glib
, meson
, ninja
, python3
, libxslt
, gtk3
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
  version = "3.45.1";

  outputs = [ "out" "man" "dev" "devdoc" ];

  # https://gitlab.gnome.org/GNOME/gnome-online-accounts/issues/87
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-online-accounts";
    rev = version;
    sha256 = "sha256-1FqOJ+nKQdK5r2fP7oAvh1LfG+T1S1NSJ+9kNZ5I76Q=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-online-accounts/-/merge_requests/95
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-accounts/-/commit/2da899c48795e9941661f3eb06fc4fc04ec7b0fa.patch";
      sha256 = "5qDiKnX9gx7eo//Qxa0+M9rsFKpg8dplA3IUZHuacmA=";
    })
  ];

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
    librest_1_0
    libxml2
    libsecret
    libsoup_3
    webkitgtk_4_1
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
