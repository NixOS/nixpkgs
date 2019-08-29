{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, pkgconfig, libxml2, glib, pipewire, fontconfig, flatpak, gsettings-desktop-schemas, acl, dbus, fuse, geoclue2, json-glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = "1.4.2";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1rs3kmpczkr6nm08kb9njnl7n3rmhh0ral0xav6f0y70pyh8whx6";
  };

  patches = [
    ./respect-path-env-var.patch
    (substituteAll {
      src = ./fix-paths.patch;
      inherit flatpak;
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig libxml2 wrapGAppsHook ];
  buildInputs = [ glib pipewire fontconfig flatpak acl dbus geoclue2 fuse gsettings-desktop-schemas json-glib ];

  doCheck = true; # XXX: investigate!

  configureFlags = [
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=$(installedTests)/libexec/installed-tests/xdg-desktop-portal"
    "installed_test_metadir=$(installedTests)/share/installed-tests/xdg-desktop-portal"
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
