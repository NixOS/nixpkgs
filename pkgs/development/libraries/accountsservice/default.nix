{ lib
, stdenv
, fetchurl
, fetchpatch
, substituteAll
, pkg-config
, glib
, shadow
, gobject-introspection
, polkit
, systemd
, coreutils
, meson
, dbus
, ninja
, python3
, vala
, gettext
}:

stdenv.mkDerivation rec {
  pname = "accountsservice";
  version = "22.07.5";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "IdRJwN6tilQ86o8R5x6wSWwDXXMOpIOTOXowKzpMfBo=";
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

    # Work around not being able to set profile picture in GNOME Settings.
    # https://github.com/NixOS/nixpkgs/issues/85357
    # https://gitlab.freedesktop.org/accountsservice/accountsservice/-/issues/98
    # https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/1629
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/accountsservice/accountsservice/-/commit/1ef3add46983af875adfed5d29954cbfb184f688.patch";
      sha256 = "N4siK4SWkwYBnFa0JJUFgahi9XBkB/nS5yc+PyH3/iM=";
    })
  ];

  nativeBuildInputs = [
    dbus
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
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
