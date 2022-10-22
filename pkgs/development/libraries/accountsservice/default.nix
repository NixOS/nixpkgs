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
}:

stdenv.mkDerivation rec {
  pname = "accountsservice";
  version = "22.08.8";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "kJmXp2kZ/n3BOKmgHOpwvWItWpMtvJ+xMBARMCOno5E=";
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
    gobject-introspection
    dbus
    glib
    polkit
    systemd
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
