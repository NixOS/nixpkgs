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

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit shadow coreutils;
    })
    ./no-create-dirs.patch
    ./Disable-methods-that-change-files-in-etc.patch
    # Fixes https://github.com/NixOS/nixpkgs/issues/72396
    ./drop-prefix-check-extensions.patch
  ];

  meta = with lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = "https://www.freedesktop.org/wiki/Software/AccountsService";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
