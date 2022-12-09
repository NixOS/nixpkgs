{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook4
, elementary-gtk-theme
, elementary-icon-theme
, glib
, granite7
, gst_all_1
, gtk4
}:

stdenv.mkDerivation rec {
  pname = "elementary-music";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "music";
    rev = version;
    sha256 = "sha256-fZbOjZd6udJWM+jWXCmGwt6cyl/lXPsgM9XeTScbqts=";
  };

  patches = [
    # Use file basename for fallback audio object title
    # https://github.com/elementary/music/pull/710
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/97a437edc7652e0b85b7d3c6fd87089c14ec02e2.patch";
      sha256 = "sha256-VmK5dKfSKWAIxfaKXsC8tjg6Pqq1XSGxJDQOZWJX92w=";
    })
    # Skip invalid files instead of stopping playback
    # https://github.com/elementary/music/pull/711
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/88f332197d2131daeff3306ec2a484a28fa4db21.patch";
      sha256 = "sha256-Zga0UmL1PAq4P58IjOuEiXGGn187a0/LHbXXze4sSpY=";
    })
    # Enable the NEXT button if repeat mode is set to ALL or ONE
    # https://github.com/elementary/music/pull/712
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/3249e3ca247dfd5ff6b14f4feeeeed63b435bcb8.patch";
      sha256 = "sha256-nx/nlSSRxu4wy8QG5yYBi0BdRoUmnyry7mwzuk5NJxU=";
    })
    # Hard code GTK styles
    # https://github.com/elementary/music/pull/723
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/4e22268d38574e56eb3b42ae201c99cc98b510db.patch";
      sha256 = "sha256-DZds7pg0vYL9vga+tP7KJHcjQTmdKHS+D+q/2aYfMmk=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite7
    gtk4
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.music";
  };
}
