{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gtk3,
  granite,
  libhandy,
  libnotify,
  vte,
  libgee,
  pcre2,
  wrapGAppsHook3,
  xvfb-run,
}:

stdenv.mkDerivation rec {
  pname = "elementary-terminal";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    rev = version;
    sha256 = "sha256-IbN01o3rojlwp4rBt8NlIPthxIPMOm/bD1rzD5Taibw=";
  };

  patches = [
    # Fix incorrect line breaks when pasting/dropping into foreground processes
    # https://github.com/elementary/terminal/pull/862
    (fetchpatch {
      url = "https://github.com/elementary/terminal/commit/8f93bc77437e45090e59266c7813436a0903d27b.patch";
      hash = "sha256-4xUFnFVUV4EIDZFprEbL+S49j5Maof5/egHPVaJAVg4=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    xvfb-run
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libhandy
    libnotify
    pcre2
    vte
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = "https://github.com/elementary/terminal";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.terminal";
  };
}
