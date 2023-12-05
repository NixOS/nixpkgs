{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, python3
, meson
, ninja
, sassc
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
  version = "7.4.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-z/6GxWfbsngySv2ziNwzhcEfTamxP1DnJ2ld9fft/1U=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    sassc
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
    updateScript = nix-update-script { };
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
