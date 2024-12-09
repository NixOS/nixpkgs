{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  appstream,
  dbus,
  flatpak,
  glib,
  granite7,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libportal-gtk4,
  libsoup_3,
  libxml2,
  polkit,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    hash = "sha256-j2S8E/sdtkir3lhN1yg4qOjcvxlriXpapsPuANPqhcc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    dbus
    flatpak
    glib
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libportal-gtk4
    libsoup_3
    libxml2
    polkit
  ];

  mesonFlags = [
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
