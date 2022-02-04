{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, desktop-file-utils
, gtk3
, libxml2
, granite
, libhandy
, libnotify
, vte
, libgee
, elementary-icon-theme
, appstream
, pcre2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-terminal";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    rev = version;
    sha256 = "sha256-4q7YQ4LxuiM/TRae1cc3ncmw7QwE1soC2Sh+GZ+Gpq0=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/terminal/pull/649
    (fetchpatch {
      url = "https://github.com/elementary/terminal/commit/15e3ace08cb25e53941249fa1ee680a1e2f871b4.patch";
      sha256 = "sha256-XVs+kq5qbX5KlxtkqxwJnatNYNeJiVLBec7sLjQsUxg=";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    libxml2
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
    libgee
    libhandy
    libnotify
    pcre2
    vte
  ];

  # See https://github.com/elementary/terminal/commit/914d4b0e2d0a137f12276d748ae07072b95eff80
  mesonFlags = [ "-Dubuntu-bionic-patched-vte=false" ];

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
