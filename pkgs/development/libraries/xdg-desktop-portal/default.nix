{ lib
, acl
, bubblewrap
, dbus
, docbook_xml_dtd_412
, docbook_xml_dtd_43
, docbook_xsl
, fetchFromGitHub
, flatpak
, fuse3
, gdk-pixbuf
, geoclue2
, glib
, gsettings-desktop-schemas
, json-glib
, libportal
, librsvg
, libxml2
, meson
, ninja
, nixosTests
, pipewire
, pkg-config
, python3
, runCommand
, stdenv
, systemdMinimal
, wrapGAppsHook
, xmlto
, enableGeoLocation ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.18.0";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    rev = finalAttrs.version;
    hash = "sha256-zp7HBqnjHVs7y6CI1LyL65/UIdxl8VgmP6DtscWYWWg=";
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
    meson
    ninja
    libxml2
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    acl
    bubblewrap
    dbus
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    flatpak
    fuse3
    glib
    gsettings-desktop-schemas
    json-glib
    libportal
    pipewire
    systemdMinimal # libsystemd
    xmlto

    # For icon validator
    gdk-pixbuf
    librsvg

    # For document-fuse installed test.
    (python3.withPackages (pp: with pp; [
      dbus-python
      docutils
      pygobject3
      pytest
      python-dbusmock
    ]))
  ] ++ lib.optionals enableGeoLocation [
    geoclue2
  ];

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
    "--libexecdir=${placeholder "out"}/libexec"
    "--localedir=${placeholder "out"}/share/locale"
    "--sysconfdir=${placeholder "out"}/etc"
    (lib.mesonOption "installed-tests" "true")
  ] ++ lib.optionals (!enableGeoLocation) [
    (lib.mesonOption "geoclue" "false")
  ];

  postInstall = ''
    moveToOutput "libexec/installed-tests" "$installedTests"
    moveToOutput "share/installed-tests" "$installedTests"
  '';

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
