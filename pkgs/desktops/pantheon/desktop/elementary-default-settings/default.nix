{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  nixos-artwork,
  glib,
  pkg-config,
  dbus,
  polkit,
  accountsservice,
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    tag = version;
    hash = "sha256-eH8bnfncyBMD7qPkdBy3zSBb79s1ALDLM58wae9hzPg=";
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
    # Do not ship elementary OS specific config files.
    "-Dapparmor-profiles=false"
    "-Dgeoclue=false"
  ];

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
