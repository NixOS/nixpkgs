{ lib
, stdenv
, nix-update-script
, appstream
, dbus
, fetchFromGitHub
, flatpak
, glib
, granite
, gtk3
, json-glib
, libgee
, libhandy
, libportal-gtk3
, libsoup_3
, libxml2
, meson
, ninja
, pkg-config
, vala
, polkit
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "7.4.0-unstable-2024-02-07";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    # Add support for AppStream 1.0.
    # https://github.com/elementary/appcenter/pull/2099
    # nixpkgs-update: no auto update
    rev = "fce55d9373bfb82953191b32e276a2129ffcb8c1";
    hash = "sha256-7VYiE1RkaqN1Yg4pFUBs6k8QjoljYFDgQ9jCTLG3uyk=";
  };

  nativeBuildInputs = [
    dbus # for pkg-config
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    appstream
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libportal-gtk3
    libsoup_3
    libxml2
    polkit
  ];

  mesonFlags = [
    # We don't have a working nix packagekit backend yet.
    "-Dpackagekit_backend=false"
    "-Dubuntu_drivers_backend=false"
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "Open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
