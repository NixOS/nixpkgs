{ lib
, acl
, autoreconfHook
, dbus
, fetchFromGitHub
, fetchpatch
, flatpak
, fuse
, geoclue2
, glib
, gsettings-desktop-schemas
, json-glib
, libportal
, libxml2
, nixosTests
, pipewire
, pkg-config
, stdenv
, substituteAll
, wrapGAppsHook
, enableGeoLocation ? true
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = "1.12.1";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1fc3LXN6wp/zQw4HQ0Q99HUvBhynHrQi2p3s/08izuE=";
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
    libxml2
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    acl
    dbus
    flatpak
    fuse
    glib
    gsettings-desktop-schemas
    json-glib
    libportal
    pipewire
  ] ++ lib.optionals enableGeoLocation [
    geoclue2
  ];

  configureFlags = [
    "--enable-installed-tests"
  ] ++ lib.optionals (!enableGeoLocation) [
    "--disable-geoclue"
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

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
