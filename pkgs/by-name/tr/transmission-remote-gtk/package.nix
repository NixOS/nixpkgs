{
  lib,
  stdenv,
  appstream-glib,
  curl,
  desktop-file-utils,
  fetchFromGitHub,
  geoip,
  gettext,
  glib,
  glib-networking,
  gtk3,
  json-glib,
  libappindicator,
  libmrss,
  libproxy,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission-remote-gtk";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
    tag = finalAttrs.version;
    hash = "sha256-xlqEfarNFUCvCYN85g+9K1eVm78ABlqwu0NqWdg0lLw=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    geoip
    gettext
    glib
    gtk3
    json-glib
    libappindicator
    libmrss
    libproxy
    libsoup_3
    # For TLS support.
    glib-networking
  ];

  doCheck = false; # Requires network access

  meta = {
    description = "GTK remote control for the Transmission BitTorrent client";
    mainProgram = "transmission-remote-gtk";
    homepage = "https://github.com/transmission-remote-gtk/transmission-remote-gtk";
    changelog = "https://github.com/transmission-remote-gtk/transmission-remote-gtk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
