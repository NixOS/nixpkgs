{ stdenv
, fetchFromGitHub
, nixosTests
, substituteAll
, autoreconfHook
, pkgconfig
, libxml2
, glib
, pipewire
, fontconfig
, flatpak
, gsettings-desktop-schemas
, acl
, dbus
, fuse
, libportal
, geoclue2
, json-glib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = "1.7.2";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "0rkwpsmbn3d3spkzc2zsd50l2r8pp4la390zcpsawaav8w7ql7xm";
  };

  patches = [
    # Hardcode paths used by x-d-p itself.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit flatpak;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    pipewire
    fontconfig
    flatpak
    acl
    dbus
    geoclue2
    fuse
    libportal
    gsettings-desktop-schemas
    json-glib
  ];

  configureFlags = [
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/xdg-desktop-portal"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/xdg-desktop-portal"
  ];

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.xdg-desktop-portal;
    };
  };

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
