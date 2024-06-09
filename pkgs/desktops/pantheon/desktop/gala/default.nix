{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, granite
, libgee
, libhandy
, bamf
, libcanberra-gtk3
, gnome-desktop
, mesa
, mutter
, gnome-settings-daemon
, wrapGAppsHook3
, sqlite
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "7.1.3-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "d5e89a9fd1bdd3fdadfbd3c9a562e738684d048f";
    sha256 = "sha256-YOAdufrnoHjICCP2e91Cl1BnS1QNbQ9yWzW140eK5Po=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    gnome-settings-daemon
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
    mesa # for libEGL
    mutter
    sqlite
    systemd
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "gala";
  };
}
