{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
, libhandy
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
  version = "5.1.1";

  repoName = "music";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1wqsn4ss9acg0scaqpg514ll2dj3bl71wly4mm79qkinhy30yv9n";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/music/pull/648
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/aea97103d59afd213467403a48788e476e47c4c3.patch";
      sha256 = "1ayj8l6lb19hhl9bhsdfbq7jgchfmpjx0qkljnld90czcksn95yx";
    })
  ];

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
    libhandy
    libnotify
    libpeas
    libsignon-glib
    libsoup
    taglib
    zeitgeist
  ];

  mesonFlags = [
    "-Dplugins=audioplayer,cdrom,ipod"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.music";
  };
}
