{ stdenv, fetchurl, pkgconfig, glib, intltool, makeWrapper, shadow
, gobject-introspection, polkit, systemd, coreutils, meson, dbus
, ninja, python3 }:

stdenv.mkDerivation rec {
  name = "accountsservice-${version}";
  version = "0.6.54";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/accountsservice/accountsservice-${version}.tar.xz";
    sha256 = "1b115n0a4yfa06kgxc69qfc1rc0w4frgs3id3029czkrhhn0ds96";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper meson ninja python3 ];

  buildInputs = [ glib intltool gobject-introspection polkit systemd dbus ];

  mesonFlags = [ "-Dsystemdsystemunitdir=etc/systemd/system"
                 "-Dlocalstatedir=/var" ];
  prePatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py

    substituteInPlace src/daemon.c --replace '"/usr/sbin/useradd"' '"${shadow}/bin/useradd"' \
                                   --replace '"/usr/sbin/userdel"' '"${shadow}/bin/userdel"'
    substituteInPlace src/user.c   --replace '"/usr/sbin/usermod"' '"${shadow}/bin/usermod"' \
                                   --replace '"/usr/bin/chage"' '"${shadow}/bin/chage"' \
                                   --replace '"/usr/bin/passwd"' '"${shadow}/bin/passwd"' \
                                   --replace '"/bin/cat"' '"${coreutils}/bin/cat"'
  '';

  patches = [
    ./no-create-dirs.patch
    ./Disable-methods-that-change-files-in-etc.patch
  ];

  preFixup = ''
    wrapProgram "$out/libexec/accounts-daemon" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/users" \
      --run "${coreutils}/bin/mkdir -p /var/lib/AccountsService/icons"
  '';

  meta = with stdenv.lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = https://www.freedesktop.org/wiki/Software/AccountsService;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
