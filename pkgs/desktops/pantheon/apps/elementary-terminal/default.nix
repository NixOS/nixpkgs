{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, desktop-file-utils
, gtk3
, granite
, libhandy
, libnotify
, vte
, libgee
, pcre2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-terminal";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    rev = version;
    sha256 = "sha256-qxjHrlpdJcfXEUan/JgU7HqBRdB36gxAb5xmd/ySsj0=";
  };

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
    granite
    gtk3
    libgee
    libhandy
    libnotify
    pcre2
    vte
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
