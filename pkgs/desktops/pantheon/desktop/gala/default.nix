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
, clutter
, gnome-settings-daemon
, wrapGAppsHook
, gexiv2
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-7RZt6gA3wyp1cxIWBYFK+fYFSZDbjHcwYa2snOmDw1Y=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # WindowManager: save/restore easing on workspace switch
    # https://github.com/elementary/gala/pull/1430
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/1f94db16c627f73af5dc69714611815e4691b5e8.patch";
      sha256 = "sha256-PLNbAXyOG0TMn1y2QIBnL6BOQVqBA+DBgPOVJo4nDr8=";
    })

    # WindowSwitcher: fix initial alt-tab switcher indicator visibility
    # https://github.com/elementary/gala/pull/1417
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/e0095415cdbfc369e6482e84b8aaffc6a04cafe7.patch";
      sha256 = "sha256-n/BJPIrUaCQtBgDotOLq/bCAAccdbL6OwciXY115HsM=";
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
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    gnome-settings-daemon
    gexiv2
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    mutter
  ];

  mesonFlags = [
    # TODO: enable this and remove --builtin flag from session-settings
    # https://github.com/NixOS/nixpkgs/pull/140429
    "-Dsystemd=false"
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
