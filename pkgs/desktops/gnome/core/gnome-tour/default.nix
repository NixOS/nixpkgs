{ lib
, stdenv
, rustPlatform
, gettext
, meson
, ninja
, fetchurl
, pkg-config
, gtk4
, glib
, gdk-pixbuf
, desktop-file-utils
, appstream-glib
, wrapGAppsHook4
, python3
, gnome
, libadwaita
, librsvg
, rustc
, cargo
}:

stdenv.mkDerivation rec {
  pname = "gnome-tour";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-8yZSqp1+8GQ3YM5jkyCCz9NkHnczt2xCm3jQl4O3xGo=";
  };

  cargoVendorDir = "vendor";

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream-glib
    cargo
    desktop-file-utils
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    librsvg
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tour";
    description = "GNOME Greeter & Tour";
    mainProgram = "gnome-tour";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
