{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, python3
, meson
, ninja
, vala
, pkg-config
, libgee
, pantheon
, gtk3
, glib
, gettext
, gsettings-desktop-schemas
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "6.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-RGukXeFmtnyCfK8pKdvTHL0t8yhEYwAiiPelTy1Xcf0=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
  ];

  propagatedBuildInputs = [
    gsettings-desktop-schemas # is_clock_format_12h uses "org.gnome.desktop.interface clock-format"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "An extension to GTK used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = "https://github.com/elementary/granite";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
