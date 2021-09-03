{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
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
  version = "6.0.0";

  repoName = "terminal";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "08akr4sv4jy9kd4s26kib6j7i8hc3vs0sp71fifv7ww4mi9cm6jc";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

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

  meta = with lib; {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = "https://github.com/elementary/terminal";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
