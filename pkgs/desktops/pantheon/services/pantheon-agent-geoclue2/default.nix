{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  gtk3,
  libgee,
  desktop-file-utils,
  geoclue2,
  granite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-geoclue2";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-DvE0/bR4mVfqCw/c/1h75M8DfCiNPZ2h6Jl6ySk1qxs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    geoclue2
    granite
    gtk3
    libgee
  ];

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/pantheon-agent-geoclue2/pull/21
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Pantheon Geoclue2 Agent";
    homepage = "https://github.com/elementary/pantheon-agent-geoclue2";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
