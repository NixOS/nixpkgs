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
<<<<<<< HEAD
  version = "6.2.2";
=======
  version = "6.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Sj89TBat2RY2Ms02M0P7gmE9tXYk1yrnPLzDwGyAFZA=";
=======
    sha256 = "sha256-ijzEMGXoH0gACem/3JaC/aOIaOQgP7Y7n48NgoDMKBk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    updateScript = nix-update-script { };
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
