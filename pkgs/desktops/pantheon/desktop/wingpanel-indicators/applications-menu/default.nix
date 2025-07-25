{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  granite,
  libgee,
  gettext,
  gtk3,
  json-glib,
  switchboard-with-plugs,
  wingpanel,
  zeitgeist,
  bc,
  libhandy,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-applications-menu";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "applications-menu";
    rev = version;
    sha256 = "sha256-bwQI41Znm75GFoXxSbWkY9daAJTMvUo+UHyyPmvzOUA=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      bc = "${bc}/bin/bc";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    json-glib
    libgee
    libhandy
    switchboard-with-plugs
    wingpanel
    zeitgeist
  ]
  ++
    # applications-menu has a plugin to search switchboard plugins
    # see https://github.com/NixOS/nixpkgs/issues/100209
    # wingpanel's wrapper will need to pick up the fact that
    # applications-menu needs a version of switchboard with all
    # its plugins for search.
    switchboard-with-plugs.buildInputs;

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = "https://github.com/elementary/applications-menu";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
