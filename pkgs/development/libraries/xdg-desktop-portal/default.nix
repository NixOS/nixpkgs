{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, libxml2, glib, pipewire, fontconfig, flatpak, acl, dbus, fuse, wrapGAppsHook, gnome3 }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = "1.1.0";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "10dv628gci6vcs0rbyp4wb6yvigw2i1jj9x7ii6ckxjir5rff5dx";
  };

  patches = [
    ./respect-path-env-var.patch
    # https://github.com/flatpak/xdg-desktop-portal/pull/263
    (fetchpatch {
      url = https://github.com/flatpak/xdg-desktop-portal/commit/5e5993b64ea43f7ba77335f98e3d6c5bf99a51b9.patch;
      sha256 = "1i753q35dgihj6vp3961i0hn2sxy2pyfx0dbqa385z0y6wz8k9xq";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig libxml2 wrapGAppsHook ];
  buildInputs = [ glib pipewire fontconfig flatpak acl dbus fuse gnome3.gsettings-desktop-schemas ];

  doCheck = true; # XXX: investigate!

  configureFlags = [
    "--enable-installed-tests"
    "--disable-geoclue" # Requires 2.5.2, not released yet
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
