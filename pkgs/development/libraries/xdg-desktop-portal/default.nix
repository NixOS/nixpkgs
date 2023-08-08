{ lib
, acl
, dbus
, fetchFromGitHub
, flatpak
, fuse3
, bubblewrap
, docbook_xml_dtd_412
, docbook_xml_dtd_43
, docbook_xsl
, systemdMinimal
, geoclue2
, glib
, gsettings-desktop-schemas
, json-glib
, libportal
, libxml2
, meson
, ninja
, nixosTests
, pipewire
, gdk-pixbuf
, librsvg
, python3
, pkg-config
, stdenv
, runCommand
, wrapGAppsHook
, xmlto
, enableGeoLocation ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.17.0";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    rev = finalAttrs.version;
    sha256 = "sha256-OGf2ohP/Qd+ff3KfJYoHu9wbCAUXCP3wm/utjqkgccE=";
  };

  patches = [
    # The icon validator copied from Flatpak needs to access the gdk-pixbuf loaders
    # in the Nix store and cannot bind FHS paths since those are not available on NixOS.
    (runCommand "icon-validator.patch" { } ''
      # Flatpak uses a different path
      substitute "${flatpak.icon-validator-patch}" "$out" \
        --replace "/icon-validator/validate-icon.c" "/src/validate-icon.c"
    '')

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook
    xmlto
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

  nativeCheckInputs = [
    python3.pkgs.pytest
    python3.pkgs.python-dbusmock
    python3.pkgs.pygobject3
    python3.pkgs.dbus-python
  ];

  mesonFlags = [
    "-Dinstalled-tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ] ++ lib.optionals (!enableGeoLocation) [
    "-Dgeoclue=false"
  ];

  doCheck = true;

  preCheck = ''
    # For test_trash_file
    export HOME=$(mktemp -d)
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
