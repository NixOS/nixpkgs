{ stdenv
, fetchFromGitHub
, python3
, meson
, ninja
, vala
, pkgconfig
, libgee
, pantheon
, gtk3
, glib
, gettext
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "12f1n07cjlc7czf642ak6964wl4fsgakc39nnmiba22z5aahfpz9";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "An extension to GTK used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = https://github.com/elementary/granite;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
