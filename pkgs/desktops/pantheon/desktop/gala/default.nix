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

    # MultitaskingView: fix allocation assertions
    # https://github.com/elementary/gala/pull/1463
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/23c7edeb0ee9b0ff0aa48c1d19fbd1739df7af78.patch";
      sha256 = "sha256-OfIDBfVEZoY8vMu9F8gtfRg4TYA1MUAG94BSOBKVGcI=";
    })

    # Work around crash when receiving notifications
    # https://github.com/elementary/gala/pull/1497
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/8842e576e3e8643a018d506605f80d152e3f5cec.patch";
      sha256 = "sha256-xu9Rh7TH0ccRU1TInTNTm+dDaCXj5aaEwDw3rBW02q8=";
    })

    # ShadowEffect: let Clutter know the shadow's size
    # https://github.com/elementary/gala/pull/1500
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/34a208e26d2ee0bf4a1689c8ad6ddfc06c540ff8.patch";
      sha256 = "sha256-KPIXNWTlKGc3JImt82t5lmcMu0bqrPx1JNv+TbsxhOg=";
    })

    # Fix awkward two-finger scroll in multitasking view
    # https://github.com/elementary/gala/pull/1499
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/c175d2662dd05e940a5b3311cc9dc285242b7fc5.patch";
      sha256 = "sha256-xsxYDagPmaNSZO/Cj7NjPqBHCc1hrqvpboAvPIg9P58=";
    })

    # Fix crash when monitor is turned off
    # https://github.com/elementary/gala/pull/1491
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/1487660812a343e6a6178881e6e7b25c2405cece.patch";
      sha256 = "sha256-YsRaWmDSg0h0RFTUOoMxlNcKoA4MNa8AhW1GGmk8qLA=";
    })

    # Fix quick zooming (next 3 patches)
    # https://github.com/elementary/gala/pull/1501
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/b9c5c9c79a045c3eef7695f74f82d851438ba7e2.patch";
      sha256 = "sha256-PGjf/B/7UQxpW0Pby7ZXuMoDlamZwEaDvaN9PaRulHU=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/49d3ddae5b631027466ff528c2935e05a8f5dc3f.patch";
      sha256 = "sha256-hvm2GcqiMYYxOLpQFXdyz325jZme7W+VYipu5goKoiU=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/45126e4c2d3736e872c05941a2047a54788cd011.patch";
      sha256 = "sha256-LdhFFFNwvF1p1LqJXer8+DOgAptiHZHlfnQBwVEIZjo=";
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
