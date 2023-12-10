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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "7.4.0-unstable-2023-12-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    # Add support for AppStream 1.0.
    # https://github.com/elementary/appcenter/pull/2099
    rev = "d93e135a0b0c9a6e0fbad18fe90d46425823a42c";
    hash = "sha256-b7xux6MuvYZFxufQ5T7DoDNBlsJ/fDR0aUY2Hk/xJoY=";
  };

  nativeBuildInputs = [
    dbus # for pkg-config
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
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
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
