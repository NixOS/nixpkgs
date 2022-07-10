{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
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
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = version;
    sha256 = "sha256-866Iky0GKQv2yUJVNY1McgXGeup5WqONN3gvoOlilGU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
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
