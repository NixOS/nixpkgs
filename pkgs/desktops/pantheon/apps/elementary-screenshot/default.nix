{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, libcanberra
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
    sha256 = "sha256-n+L08C/W5YnHZ5P3F1NGUYE2SH94sc4+kr1x+wXZ+cw=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/screenshot/pull/241
    (fetchpatch {
      url = "https://github.com/elementary/screenshot/commit/80a5d942e813dd098e1ef0f6629b81d2ccef05ae.patch";
      sha256 = "sha256-jOQuzUJvsjqytplLcW9BeIxzi9+/k2GFa4hHVZ3+wts=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libgee
    libhandy
  ];

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
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.screenshot";
  };
}
