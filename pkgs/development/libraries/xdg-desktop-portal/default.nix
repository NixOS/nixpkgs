{ lib
, fetchFromGitHub
, flatpak
, fuse3
, bubblewrap
, docbook_xml_dtd_412
, docbook_xml_dtd_43
, docbook_xsl
, docutils
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
  version = "1.18.4";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    rev = finalAttrs.version;
    hash = "sha256-o+aO7uGewDPrtgOgmp/CE2uiqiBLyo07pVCFrtlORFQ=";
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

    # `XDG_DESKTOP_PORTAL_DIR` originally was used for upstream tests. But we are making use
    # of this in the NixOS module, this actually blocks any configs from being loaded since
    # configs are not expected to be placed in a portal implementation or even under the
    # `share/xdg-desktop-portal/portals/` path.
    ./separate-env-for-portal-config.patch
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    docutils # for rst2man
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook
    xmlto
  ];

  buildInputs = [
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
    "--sysconfdir=/etc"
    "-Dinstalled-tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ] ++ lib.optionals (!enableGeoLocation) [
    "-Dgeoclue=disabled"
  ];

  doCheck = true;

  preCheck = ''
    # For test_trash_file
    export HOME=$(mktemp -d)

    # Upstream disables a few tests in CI upstream as they are known to
    # be flaky. Let's disable those downstream as hydra exhibits similar
    # flakes:
    #   https://github.com/NixOS/nixpkgs/pull/270085#issuecomment-1840053951
    export TEST_IN_CI=1
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
    homepage = "https://flatpak.github.io/xdg-desktop-portal/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
})
