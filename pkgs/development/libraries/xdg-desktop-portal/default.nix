{
  lib,
  fetchFromGitHub,
  flatpak,
  fuse3,
  bubblewrap,
  docutils,
  systemdMinimal,
  geoclue2,
  glib,
  gsettings-desktop-schemas,
  json-glib,
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
  wrapGAppsNoGuiHook,
  bash,
  dbus,
  gst_all_1,
  libgudev,
  umockdev,
  replaceVars,
  enableGeoLocation ? true,
  enableSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal";
  version = "1.20.3";

  outputs = [
    "out"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal";
    tag = finalAttrs.version;
    hash = "sha256-ntTGEsk8GlXkp3i9RtF+T7jqnNdL2GVbu05d68WVTYc=";
  };

  patches = [
    # The icon validator copied from Flatpak needs to access the gdk-pixbuf loaders
    # in the Nix store and cannot bind FHS paths since those are not available on NixOS.
    (replaceVars ./fix-icon-validation.patch {
      inherit (builtins) storeDir;
    })

    # Same for the sound validator, except the gdk-pixbuf part.
    (replaceVars ./fix-sound-validation.patch {
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
    docutils # for rst2man
    glib
    meson
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    flatpak
    fuse3
    bubblewrap
    glib
    gsettings-desktop-schemas
    json-glib
    pipewire
    gst_all_1.gst-plugins-base
    libgudev

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
    dbus
    gdk-pixbuf
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gobject-introspection

    # NB: this Python is used both for build-time tests
    # and for installed (VM) tests, so it includes dependencies
    # for both
    (python3.withPackages (ps: [
      ps.pytest
      ps.python-dbusmock
      ps.pygobject3
      ps.dbus-python
    ]))
    umockdev
  ];

  checkInputs = [ umockdev ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dinstalled-tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Ddocumentation=disabled" # pulls in a whole lot of extra stuff
    (lib.mesonEnable "systemd" enableSystemd)
  ]
  ++ lib.optionals (!enableGeoLocation) [
    "-Dgeoclue=disabled"
  ]
  ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    "-Dtests=disabled"
  ];

  strictDeps = true;

  doCheck = true;

  postPatch = ''
    # until/unless bubblewrap ships a pkg-config file, meson has no way to find it when cross-compiling.
    substituteInPlace meson.build \
      --replace-fail "find_program('bwrap'"  "find_program('${lib.getExe bubblewrap}'"

    patchShebangs src/generate-method-info.py
    patchShebangs tests/run-test.sh
  '';

  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    # For test_trash_file
    export HOME=$(mktemp -d)

    # Upstream disables a few tests in CI upstream as they are known to
    # be flaky. Let's disable those downstream as hydra exhibits similar
    # flakes:
    #   https://github.com/NixOS/nixpkgs/pull/270085#issuecomment-1840053951
    export XDP_TEST_IN_CI=1

    # need to set this ourselves, because the tests will set LD_PRELOAD=libumockdev-preload.so,
    # which can't be found because it's not in default rpath
    export LD_PRELOAD=${lib.getLib umockdev}/lib/libumockdev-preload.so
  '';

  # We can't disable the installedTests output when doCheck is disabled,
  # because that produces an infinite recursion.
  preFixup = lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    mkdir $installedTests
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.xdg-desktop-portal;

      validate-icon = runCommand "test-icon-validation" { } ''
        ${finalAttrs.finalPackage}/libexec/xdg-desktop-portal-validate-icon --ruleset=desktop --sandbox --path=${../../../applications/audio/zynaddsubfx/ZynLogo.svg} > "$out"
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
