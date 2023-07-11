{ lib
, stdenv
, fetchFromGitHub
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
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "music";
    rev = version;
    sha256 = "sha256-L+E5gDtIgVkfmOIhzS7x8vtyMJYqx/UQpYMChrt2Tgo=";
  };

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
    updateScript = nix-update-script { };
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
