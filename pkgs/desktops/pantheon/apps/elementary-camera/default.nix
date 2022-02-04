{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, appstream
, desktop-file-utils
, gettext
, libxml2
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, elementary-icon-theme
, glib
, granite
, gst_all_1
, gtk3
, libcanberra
, libgee
, libhandy
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

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/camera/pull/216
    (fetchpatch {
      url = "https://github.com/elementary/camera/commit/ead143b7e3246c5fa9bb37c95d491fb07cea9e04.patch";
      sha256 = "sha256-2zGigUi6DpjJx8SEvAE3Q3jrm7MggOvLc72lAPMPvs4=";
    })
  ];

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
    elementary-icon-theme
    glib
    granite
    gtk3
    libcanberra
    libgee
    libhandy
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    # gtkSupport needed for gtksink
    # https://github.com/elementary/camera/issues/181
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-ugly
    gstreamer
  ]);

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
