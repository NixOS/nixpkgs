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
