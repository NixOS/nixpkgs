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
  gst_all_1,
  libgudev,
  umockdev,
  sphinx,
  substituteAll,
  enableGeoLocation ? true,
  enableSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.19.2";

  outputs = [
    "out"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    tag = finalAttrs.version;
    hash = "sha256-LV9+t8VAA+gdUKzPMALP9q6EE0Y2hJe/i8zfh7Zgmu4=";
  };

  patches = [
    # The icon validator copied from Flatpak needs to access the gdk-pixbuf loaders
    # in the Nix store and cannot bind FHS paths since those are not available on NixOS.
    (substituteAll {
      src = ./fix-icon-validation.patch;
      inherit (builtins) storeDir;
    })

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Look for portal definitions under path from `NIX_XDG_DESKTOP_PORTAL_DIR` environment variable.
    # While upstream has `XDG_DESKTOP_PORTAL_DIR`, it is meant for tests and actually blocks
    # any configs from being loaded from anywhere else.
    ./nix-pkgdatadir-env.patch

    # test tries to read /proc/cmdline, which is not intended to be accessible in the sandbox
    ./trash-test.patch
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
    wrapGAppsHook3
    xmlto
    sphinx
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    # For document-fuse installed test.
    (python3.withPackages (
      pp: with pp; [
        pygobject3
        sphinxext-opengraph
        sphinx-copybutton
        furo
      ]
    ))
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
      gst_all_1.gst-plugins-base
      libgudev
      umockdev

      # For icon validator
      gdk-pixbuf
      librsvg
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

  postPatch = ''
    # until/unless bubblewrap ships a pkg-config file, meson has no way to find it when cross-compiling.
    substituteInPlace meson.build \
      --replace-fail "find_program('bwrap'"  "find_program('${lib.getExe bubblewrap}'"

    # Disable test failing with libportal 0.9.0
    ${
      assert (lib.versionOlder finalAttrs.version "1.20.0");
      "# TODO: Remove when updating to x-d-p 1.20.0"
    }
    substituteInPlace tests/test-portals.c \
      --replace-fail 'g_test_add_func ("/portal/notification/bad-arg", test_notification_bad_arg);' ""

    patchShebangs src/generate-method-info.py
    patchShebangs doc/fix-rst-dbus.py
  '';

  preCheck = ''
    # For test_trash_file
    export HOME=$(mktemp -d)

    # Upstream disables a few tests in CI upstream as they are known to
    # be flaky. Let's disable those downstream as hydra exhibits similar
    # flakes:
    #   https://github.com/NixOS/nixpkgs/pull/270085#issuecomment-1840053951
    export XDP_TEST_IN_CI=1

    export XDP_VALIDATE_SOUND_INSECURE=1 # For validate-sound: Failed to create gstreamer discoverer: Couldn't create 'uridecodebin' element

    export LD_PRELOAD=$LD_PRELOAD:${lib.getLib umockdev}/lib/libumockdev-preload.so
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

  meta = {
    description = "Desktop integration portals for sandboxed apps";
    homepage = "https://flatpak.github.io/xdg-desktop-portal";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.linux;
  };
})
