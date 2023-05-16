{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, libcanberra
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot";
<<<<<<< HEAD
  version = "6.0.4";
=======
  version = "6.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-xG67a19ySuYc5IXlEkaqhnDpDa2krF2y6PnhJkd/rOg=";
=======
    sha256 = "sha256-7BrowiMUDcf0raeOEFen2V3nenymgE6Rg5a3RilMQaI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  buildInputs = [
    granite
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.screenshot";
  };
}
