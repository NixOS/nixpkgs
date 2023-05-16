{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, glib
, shadow
, gobject-introspection
, polkit
, systemd
, coreutils
, meson
, mesonEmulatorHook
, dbus
, ninja
, python3
, vala
, gettext
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "accountsservice";
<<<<<<< HEAD
  version = "23.13.9";
=======
  version = "22.08.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "rdpM3q4k+gmS598///nv+nCQvjrCM6Pt/fadWpybkk8=";
=======
    sha256 = "kJmXp2kZ/n3BOKmgHOpwvWItWpMtvJ+xMBARMCOno5E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Hardcode dependency paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit shadow coreutils;
    })

    # Do not try to create directories in /var, that will not work in Nix sandbox.
    ./no-create-dirs.patch

    # Disable mutating D-Bus methods with immutable /etc.
    ./Disable-methods-that-change-files-in-etc.patch

    # Do not ignore third-party (e.g Pantheon) extensions not matching FHS path scheme.
    # Fixes https://github.com/NixOS/nixpkgs/issues/72396
    ./drop-prefix-check-extensions.patch
<<<<<<< HEAD

    # Detect DM type from config file.
    # `readlink display-manager.service` won't return any of the candidates.
    ./get-dm-type-from-config.patch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    #  meson.build:88:2: ERROR: Can not run test applications in this cross environment.
    mesonEmulatorHook
  ];

  buildInputs = [
    dbus
    gettext
    glib
    polkit
    systemd
    libxcrypt
  ];

  mesonFlags = [
    "-Dadmin_group=wheel"
    "-Dlocalstatedir=/var"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = "https://www.freedesktop.org/wiki/Software/AccountsService";
    license = licenses.gpl3Plus;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ pSub ]);
    platforms = platforms.linux;
  };
}
