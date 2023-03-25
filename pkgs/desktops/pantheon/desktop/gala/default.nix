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
, mesa
, mutter
, gnome-settings-daemon
, wrapGAppsHook
, gexiv2
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-YHmmF9tYDgMieLCs9My7NU16Ysq4n2sxWT/7MpaerkI=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # WindowClone: Don't calculate offset
    # https://github.com/elementary/gala/pull/1567
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/b7139add2333e5419afd1c82c3790d85044c1f76.patch";
      sha256 = "sha256-QhBARbA3YEXB/RIM/gmFiry1IzGvFFQVXGDs0kGjf20=";
    })

    # Map notification windows manually while switching workspace
    # https://github.com/elementary/gala/pull/1577
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/97b33173e2ee8b4a4af3fe0513b6d264de9d9b2a.patch";
      sha256 = "sha256-y2PicvHxtKlZTpr6a0Hua1ppXpRwDItsIoGG2r+DAjQ=";
    })

    # Use ClickAction for FramedBackground and close buttons
    # https://github.com/elementary/gala/pull/1579
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/79453b324d2e737ba32124212632e1269c6c9af1.patch";
      sha256 = "sha256-ipOoY3dn0Hs1U2d9OER+ZfgC5AL4yay4FD8ongID/xY=";
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
    gnome-settings-daemon
    gexiv2
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    mesa # for libEGL
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
