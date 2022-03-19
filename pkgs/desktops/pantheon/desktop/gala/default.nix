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
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-f/WDm9/+lXgplg9tGpct4f+1cOhKgdypwiDRBhewRGw=";
  };

  patches = [
    ./plugins-dir.patch
    # Session crashes when switching windows with Alt+Tab
    # https://github.com/elementary/gala/issues/1312
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/cc83db8fe398feae9f3e4caa8352b65f0c8c96d4.patch";
      sha256 = "sha256-CPO3EHIzqHAV6ZLHngivCdsD8je8CK/NHznfxSEkhzc=";
    })
    # WindowSwitcher: Clear indicator background
    # https://github.com/elementary/gala/pull/1318
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/cce53acffecba795b6cc48916d4621a47996d2c9.patch";
      sha256 = "sha256-5aTZE6poo4sQMTLfk9Nhw4G4BW8i9dvpWktizRIS58Q=";
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
