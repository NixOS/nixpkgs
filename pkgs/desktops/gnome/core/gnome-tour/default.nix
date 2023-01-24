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
, wrapGAppsHook
, python3
, gnome
, libadwaita
, librsvg
, rustc
, rust
, writeText
, cargo
}:

stdenv.mkDerivation rec {
  pname = "gnome-tour";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-E1HkGWJ/vXx3GTKm7xrYDAvy5oKMSUigYgaJhN2zzIg=";
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
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    librsvg
  ];

  mesonFlags =
    let
      # ERROR: 'rust' compiler binary not defined in cross or native file
      crossFile = writeText "cross-file.conf" ''
        [binaries]
        rust = [ 'rustc', '--target', '${rust.toRustTargetSpec stdenv.hostPlatform}' ]
      '';
    in
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "--cross-file=${crossFile}" ];

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
