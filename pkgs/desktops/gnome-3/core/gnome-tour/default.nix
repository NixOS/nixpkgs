{ stdenv
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
, gnome3
, libhandy
, librsvg
}:

rustPlatform.buildRustPackage rec {
  pname = "gnome-tour";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-hV/C/Lyz6e9zhe3FRw4Sox5gMqThDP57wVCTgcekjng=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk3
    libhandy
    librsvg
  ];

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tour";
    description = "GNOME Greeter & Tour";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
