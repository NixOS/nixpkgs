{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, nixos-artwork
, glib
, pkg-config
, dbus
, polkit
, accountsservice
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "7.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-j4K8qYwfu6/s4qnTSzwv6KRsk9f+Qr/l1bhLywKMHMU=";
=======
    sha256 = "sha256-RPnERK93GCfWyw1sIW5BitCIo11/t1koV4r1+NF5NdI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    accountsservice
    dbus
    glib # polkit requires
    meson
    ninja
    pkg-config
    polkit
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
    "-Dplank-dockitems=false"
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preInstall = ''
    # Install our override for plank dockitems as the desktop file path is different.
    schema_dir=$out/share/glib-2.0/schemas
    install -D ${./overrides/plank-dockitems.gschema.override} $schema_dir/plank-dockitems.gschema.override

    # Our launchers that use paths at /run/current-system/sw/bin
    mkdir -p $out/etc/skel/.config/plank/dock1
    cp -avr ${./launchers} $out/etc/skel/.config/plank/dock1/launchers
  '';

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
