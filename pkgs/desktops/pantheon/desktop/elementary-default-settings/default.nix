{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, nixos-artwork
, glib
, pkg-config
, dbus
, polkit
, accountsservice
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = version;
    sha256 = "sha256-V8jzebnMD41U0ycu66xIZmssoqrKVS+4L70mqc3GEzg=";
  };

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    accountsservice
    dbus
    polkit
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
  ];

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
