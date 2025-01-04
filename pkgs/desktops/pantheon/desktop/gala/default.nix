{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, bamf
, libcanberra-gtk3
, gnome-desktop
, mutter
, gnome-settings-daemon
, wrapGAppsHook3
, gexiv2
, systemd
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "7.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-0fDbR28gh7F8Bcnofn48BBP1CTsYnfmY5kG72ookOXw=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # Start gala-daemon internally (needed for systemd managed gnome-session)
    # https://github.com/elementary/gala/pull/1844
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/351722c5a4fded46992b725e03dc94971c5bd31f.patch";
      hash = "sha256-RvdVHQjCUNmLrROBZTF+m1vE2XudtQZjk/YW28P/vKc=";
    })

    # InternalUtils: Fix window placement
    # https://github.com/elementary/gala/pull/1913
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/2d30bee678788c5a853721d16b5b39c997b23c02.patch";
      hash = "sha256-vhGFaLpJZFx1VTfjY1BahQiOUvBPi0dBSXLGhYc7r8A=";
    })
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
    bamf
    gnome-settings-daemon
    gexiv2
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    mutter
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
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "gala";
  };
}
