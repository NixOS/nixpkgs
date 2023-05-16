{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
<<<<<<< HEAD
, gtk4
, glib
, granite7
, libadwaita
, libgee
, wrapGAppsHook4
=======
, python3
, gtk3
, glib
, granite
, libgee
, libhandy
, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, appstream
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "7.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-hAObgD2Njg1We0rGEu508khoBo+hj0DQAB7N33CVDiM=";
=======
    sha256 = "sha256-QvqyaI9szZuYuE3D6o4zjr5J6mvEzNHqTBWii+gjyMc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # The standard location to the metadata pool where metadata
    # will be read from is likely hardcoded as /usr/share/metainfo
    # https://github.com/ximion/appstream/blob/v0.15.2/src/as-pool.c#L117
    # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
    ./fix-metadata-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
    vala
    wrapGAppsHook4
=======
    python3
    vala
    wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    appstream
<<<<<<< HEAD
    granite7
    gtk4
    libadwaita
    libgee
    glib
  ];

=======
    granite
    gtk3
    libgee
    libhandy
    glib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = "https://github.com/elementary/feedback";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.feedback";
  };
}
