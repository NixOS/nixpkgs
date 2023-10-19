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
, libsoup
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
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-L6MGbzzujr4tEB2Cpd7IU+3mOtSCt2hLPw4mOfZ4TkQ=";
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
    libsoup
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
