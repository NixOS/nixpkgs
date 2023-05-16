{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter
, evolution-data-server
, folks
, geoclue2
, geocode-glib_2
, granite
, gtk3
, libchamplain_libsoup3
, libgee
, libhandy
, libical
<<<<<<< HEAD
, libportal-gtk3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "elementary-calendar";
<<<<<<< HEAD
  version = "7.0.0";
=======
  version = "6.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-qZvSzhLGr4Gg9DSJ638IQRLlPiZkbJUCJ7tZ8ZFZZ1E=";
  };

=======
    sha256 = "sha256-psUVgl/7pmmf+8dP8ghBx5C1u4UT9ncXuVYvDJOYeOI=";
  };

  patches = [
    # build: support evolution-data-server 3.46
    # https://github.com/elementary/calendar/pull/758
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/62c20e5786accd68b96c423b04e32c043e726cac.patch";
      sha256 = "sha256-xatxoSwAIHiUA03vvBdM8HSW27vhPLvAxEuGK0gLiio=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter
    evolution-data-server
    folks
    geoclue2
    geocode-glib_2
    granite
    gtk3
    libchamplain_libsoup3
    libgee
    libhandy
    libical
<<<<<<< HEAD
    libportal-gtk3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calendar";
  };
}
