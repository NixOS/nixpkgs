{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, python3
, meson
, ninja
, vala
, pkg-config
, libgee
, gtk4
, glib
, gettext
, gsettings-desktop-schemas
, gobject-introspection
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "7.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-fuyjQDH3C8qRYuAfQDDeW3aSWVTLtGzMAjcuAHCB1Zw=";
  };

  patches = [
    # MessageDialog: Fix large height bug
    # https://github.com/elementary/granite/pull/616
    (fetchpatch {
      url = "https://github.com/elementary/granite/commit/28e9b60fc8257b2d8e76412518e96a7e03efc6e4.patch";
      sha256 = "sha256-3VH5bhX8tuNR3Iabz3JjkLfVVyO5eSnYacFgdqurU0A=";
      excludes = [ "data/granite.appdata.xml.in" ];
    })
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas # is_clock_format_12h uses "org.gnome.desktop.interface clock-format"
    gtk4
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.granite7";
    };
  };

  meta = with lib; {
    description = "An extension to GTK used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = "https://github.com/elementary/granite";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "granite-7-demo";
  };
}
