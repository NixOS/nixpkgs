{ lib, stdenv
, fetchFromGitHub
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
  version = "1.8.1";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "sha256-tuRKCBj9ELC7yFPs/Sut/EdO+L8nwW3S8NWU+XedAF8=";
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
