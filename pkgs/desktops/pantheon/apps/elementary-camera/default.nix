{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, python3
, gettext
, libxml2
, gtk3
, granite
, libgee
, libhandy
, gst_all_1
, libcanberra
, clutter-gtk
, clutter-gst
, elementary-icon-theme
, appstream
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-camera";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = version;
    sha256 = "sha256-xIv+mOlZV58XD0Z6Vc2wA1EQUxT5BaQ0zhYc9v+ne1w=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gst
    clutter-gtk
    elementary-icon-theme
    granite
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gstreamer
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
    description = "Camera app designed for elementary OS";
    homepage = "https://github.com/elementary/camera";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.camera";
  };
}
