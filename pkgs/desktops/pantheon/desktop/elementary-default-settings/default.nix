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
  version = "7.1.0-unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = "a089b3919c6091afa8b2cca697ffe17bd9f51a75";
    sha256 = "sha256-PbuqoqUyXc13lJH1D8TL/EcKE8q9Cd/GQf9Ck+3KsiQ=";
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
