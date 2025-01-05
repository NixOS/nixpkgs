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
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    rev = version;
    sha256 = "sha256-Pr2Jm37vuw1DOx63BXKT3oPK6C7i5v9ObYFNR6Hvhns=";
  };

  patches = [
    # Fix clear and reset actions when ongoing foreground process
    # https://github.com/elementary/terminal/pull/823
    (fetchpatch {
      url = "https://github.com/elementary/terminal/commit/3c84bcb98ecdadb4d5e0c7a8f52fb5238f5e92f0.patch";
      hash = "sha256-XViJR+vj+qy2A1nZa3Pdo8uY24tS4ZqZKjTAyPN9sPA=";
    })
    # Only reset/clear screen when <Shift> is pressed
    # https://github.com/elementary/terminal/pull/827
    (fetchpatch {
      url = "https://github.com/elementary/terminal/commit/91b93d883c2b8a8549d9743292d6a564e3b2d3cb.patch";
      hash = "sha256-3opiRhQLJCYFDwDjEbm0CZ9y8CF/6biU+cJk1Ideyks=";
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
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.terminal";
  };
}
