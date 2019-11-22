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
  version = "5.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0z40vhcp2w8s8rnc56pzvjc4s77bln8k84rwwypivjmk3lhpw1vi";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
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
