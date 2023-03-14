{ lib
, acl
, autoreconfHook
, dbus
, fetchFromGitHub
, flatpak
, fuse3
, bubblewrap
, systemdMinimal
, geoclue2
, glib
, gsettings-desktop-schemas
, json-glib
, libportal
, libxml2
, nixosTests
, pipewire
, gdk-pixbuf
, librsvg
, python3
, pkg-config
, stdenv
, runCommand
, wrapGAppsHook
, enableGeoLocation ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.16.0";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    rev = finalAttrs.version;
    sha256 = "sha256-5VNauinTvZrSaQzyP/quL/3p2RPcTJUDLscEQMJpvYA=";
  };

  patches = [
    # The icon validator copied from Flatpak needs to access the gdk-pixbuf loaders
    # in the Nix store and cannot bind FHS paths since those are not available on NixOS.
    (runCommand "icon-validator.patch" { } ''
      # Flatpak uses a different path
      substitute "${flatpak.icon-validator-patch}" "$out" \
        --replace "/icon-validator/validate-icon.c" "/src/validate-icon.c"
    '')
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
    fuse3
    bubblewrap
    systemdMinimal # libsystemd
    glib
    gsettings-desktop-schemas
    json-glib
    libportal
    pipewire

    # For icon validator
    gdk-pixbuf
    librsvg

    # For document-fuse installed test.
    (python3.withPackages (pp: with pp; [
      pygobject3
    ]))
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

      validate-icon = runCommand "test-icon-validation" { } ''
        ${finalAttrs.finalPackage}/libexec/xdg-desktop-portal-validate-icon --sandbox 512 512 ${../../../applications/audio/zynaddsubfx/ZynLogo.svg} > "$out"
        grep format=svg "$out"
      '';
    };
  };

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
})
