{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, python3
, libgee
, clutter-gtk
, json-glib
, libgda
, libgpod
, libnotify
, libpeas
, libsoup
, zeitgeist
, gst_all_1
, taglib
, libdbusmenu
, libsignon-glib
, libaccounts-glib
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-music";
  version = "5.0.5";

  repoName = "music";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-3GZoBCu9rF+BnNk9APBzKWO1JYg1XYWwrEvwcjWvYDE=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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

  buildInputs = with gst_all_1; [
    clutter-gtk
    elementary-icon-theme
    granite
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    json-glib
    libaccounts-glib
    libdbusmenu
    libgda
    libgee
    libgpod
    libnotify
    libpeas
    libsignon-glib
    libsoup
    taglib
    zeitgeist
  ];

  mesonFlags = [
    "-Dplugins=lastfm,audioplayer,cdrom,ipod"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
