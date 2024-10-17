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
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = version;
    sha256 = "sha256-EjvHduhR7ckcsEePi0rhlvn1PQ6TqYeFK0lth3OUpPE=";
  };

  nativeBuildInputs = [
    accountsservice
    dbus
    glib # polkit requires
    meson
    ninja
    pkg-config
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
