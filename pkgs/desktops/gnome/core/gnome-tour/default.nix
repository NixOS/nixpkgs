{ lib
, stdenv
, rustPlatform
, gettext
, meson
, ninja
, fetchurl
, pkg-config
, gtk3
, glib
, gdk-pixbuf
, desktop-file-utils
, appstream-glib
, wrapGAppsHook
, python3
, gnome
, libhandy
, librsvg
, rustc
, cargo
}:

stdenv.mkDerivation rec {
  pname = "gnome-tour";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-cGMiOGmgdHJ0FL7H23ONhQYhbuhMz8O8p9rFLkmMG/k=";
  };

  cargoVendorDir = "vendor";

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
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk3
    libhandy
    librsvg
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tour";
    description = "GNOME Greeter & Tour";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
