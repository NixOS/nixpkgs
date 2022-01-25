{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nixosTests
, substituteAll
, autoreconfHook
, pkg-config
, libxml2
, glib
, pipewire
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
  version = "1.10.1";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "Q1ZP/ljdIxJHg+3JaTL/LIZV+3cK2+dognsTC95udVA=";
  };

  patches = [
    # Hardcode paths used by x-d-p itself.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit flatpak;
    })
    # Fixes the issue in https://github.com/flatpak/xdg-desktop-portal/issues/636
    # Remove it when the next stable release arrives
    (fetchpatch {
      url = "https://github.com/flatpak/xdg-desktop-portal/commit/d7622e15ff8fef114a6759dde564826d04215a9f.patch";
      sha256 = "sha256-vmfxK4ddG6Xon//rpiz6OiBsDLtT0VG5XyBJG3E4PPs=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    pipewire
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

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
