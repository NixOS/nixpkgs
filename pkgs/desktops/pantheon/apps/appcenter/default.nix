{ lib
, stdenv
, nix-update-script
, appstream
, dbus
, fetchFromGitHub
, flatpak
, glib
, granite
, gtk3
, json-glib
, libgee
, libhandy
, libsoup
, libxml2
, meson
, ninja
<<<<<<< HEAD
=======
, packagekit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, python3
, vala
, polkit
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
<<<<<<< HEAD
  version = "7.3.0";
=======
  version = "7.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Lj3j812XaCIN+TFSDAvIgtl49n5jG4fVlAFvrWqngpM=";
  };

=======
    sha256 = "sha256-jtNPRsq33bIn3jy3F63UNrwrhaTBYbRYLDxyxgAXjIc=";
  };

  patches = [
    # Having a working nix packagekit backend will supersede this.
    # https://github.com/NixOS/nixpkgs/issues/177946
    ./disable-packagekit-backend.patch
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    dbus # for pkg-config
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    libxml2
<<<<<<< HEAD
=======
    packagekit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    polkit
  ];

  mesonFlags = [
<<<<<<< HEAD
    # We don't have a working nix packagekit backend yet.
    "-Dpackagekit_backend=false"
    "-Dubuntu_drivers_backend=false"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
