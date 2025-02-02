{
  lib,
  fetchFromGitHub,
  flatpak,
  fuse3,
  bubblewrap,
  docbook_xml_dtd_412,
  docbook_xml_dtd_43,
  docbook_xsl,
  docutils,
  systemdMinimal,
  geoclue2,
  glib,
  gsettings-desktop-schemas,
  json-glib,
  libportal,
  libxml2,
  meson,
  ninja,
  nixosTests,
  pipewire,
  gdk-pixbuf,
  librsvg,
  gobject-introspection,
  python3,
  pkg-config,
  stdenv,
  runCommand,
  wrapGAppsHook3,
  xmlto,
  bash,
  enableGeoLocation ? true,
  enableSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.18.4";

  outputs = [
    "out"
    "installedTests"
  ];

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

    # Look for portal definitions under path from `NIX_XDG_DESKTOP_PORTAL_DIR` environment variable.
    # While upstream has `XDG_DESKTOP_PORTAL_DIR`, it is meant for tests and actually blocks
    # any configs from being loaded from anywhere else.
    ./nix-pkgdatadir-env.patch

    # test tries to read /proc/cmdline, which is not intended to be accessible in the sandbox
    ./trash-test.patch

    # Install files required to be in XDG_DATA_DIR of the installed tests
    # Merged PR https://github.com/flatpak/xdg-desktop-portal/pull/1444
    ./installed-tests-share.patch
  ];

  # until/unless bubblewrap ships a pkg-config file, meson has no way to find it when cross-compiling.
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "find_program('bwrap'"  "find_program('${lib.getExe bubblewrap}'"
  '';

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xml_dtd_43
    docbook_xsl
    docutils # for rst2man
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    xmlto
  ];

  buildInputs =
    [
      flatpak
      fuse3
      bubblewrap
      glib
      gsettings-desktop-schemas
      json-glib
      libportal
      pipewire

      # For icon validator
      gdk-pixbuf
      librsvg

      # For document-fuse installed test.
      (python3.withPackages (
        pp: with pp; [
          pygobject3
        ]
      ))
      bash
    ]
    ++ lib.optionals enableGeoLocation [
      geoclue2
    ]
    ++ lib.optionals enableSystemd [
      systemdMinimal # libsystemd
    ];

  nativeCheckInputs = [
    gobject-introspection
    python3.pkgs.pytest
    python3.pkgs.python-dbusmock
    python3.pkgs.pygobject3
    python3.pkgs.dbus-python
  ];

  mesonFlags =
    [
      "--sysconfdir=/etc"
      "-Dinstalled-tests=true"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      (lib.mesonEnable "systemd" enableSystemd)
    ]
    ++ lib.optionals (!enableGeoLocation) [
      "-Dgeoclue=disabled"
    ]
    ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
      "-Dpytest=disabled"
    ];

  strictDeps = true;

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

  postFixup =
    let
      documentFuse = "${placeholder "installedTests"}/libexec/installed-tests/xdg-desktop-portal/test-document-fuse.py";
      testPortals = "${placeholder "installedTests"}/libexec/installed-tests/xdg-desktop-portal/test-portals";

    in
    ''
      if [ -x '${documentFuse}' ] ; then
        wrapGApp '${documentFuse}'
        wrapGApp '${testPortals}'
        # (xdg-desktop-portal:995): xdg-desktop-portal-WARNING **: 21:21:55.673: Failed to get GeoClue client: Timeout was reached
        # xdg-desktop-portal:ERROR:../tests/location.c:22:location_cb: 'res' should be TRUE
        # https://github.com/flatpak/xdg-desktop-portal/blob/1d6dfb57067dec182b546dfb60c87aa3452c77ed/tests/location.c#L21
        rm $installedTests/share/installed-tests/xdg-desktop-portal/test-portals-location.test
      fi
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
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
})
