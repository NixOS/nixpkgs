{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gtk3
, granite
, libgee
, libhandy
<<<<<<< HEAD
=======
, clutter-gst
, clutter-gtk
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gst_all_1
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-O98478E3NlY2NYqjyy8mcXZ3lG+wIV+VrPzdzOp44yA=";
=======
    sha256 = "sha256-QQcuhYe3/ZMqQEFJS72+vr1AzJC9Y7mr5Fa5yFsNYIc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    vala
    wrapGAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
=======
    clutter-gst
    clutter-gtk
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    granite
    gtk3
    libgee
    libhandy
  ] ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
<<<<<<< HEAD
    # https://github.com/elementary/videos/issues/356
    (gst-plugins-good.override { gtkSupport = true; })
=======
    gst-plugins-good
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gst-plugins-ugly
    gstreamer
  ]);

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.videos";
  };
}
