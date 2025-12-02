{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  pkg-config,
  meson,
  ninja,
  libevdev,
  mtdev,
  udev,
  wacomSupport ? true,
  libwacom,
  documentationSupport ? false,
  doxygen,
  graphviz,
  runCommand,
  eventGUISupport ? false,
  cairo,
  glib,
  gtk3,
  testsSupport ? false,
  check,
  valgrind,
  python3,
  nixosTests,
  wayland-scanner,
  udevCheckHook,
}:

let
  mkFlag = optSet: flag: "-D${flag}=${lib.boolToString optSet}";

  sphinx-build =
    let
      env = python3.withPackages (
        pp: with pp; [
          sphinx
          recommonmark
          sphinx-rtd-theme
        ]
      );
    in
    # Expose only the sphinx-build binary to avoid contaminating
    # everything with Sphinx’s Python environment.
    runCommand "sphinx-build" { } ''
      mkdir -p "$out/bin"
      ln -s "${env}/bin/sphinx-build" "$out/bin"
    '';
in

stdenv.mkDerivation rec {
  pname = "libinput";
  version = "1.29.2";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libinput";
    rev = version;
    hash = "sha256-oxDGUbZebxAmBd2j51qV9Jn8SXBjUX2NPRgkxbDz7Dk=";
  };

  patches = [
    ./udev-absolute-path.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    udevCheckHook
  ]
  ++ lib.optionals documentationSupport [
    doxygen
    graphviz
    sphinx-build
  ];

  buildInputs = [
    libevdev
    mtdev
    (python3.withPackages (
      pp: with pp; [
        pp.libevdev # already in scope
        pyudev
        pyyaml
        setuptools
      ]
    ))
  ]
  ++ lib.optionals wacomSupport [
    libwacom
  ]
  ++ lib.optionals eventGUISupport [
    # GUI event viewer
    cairo
    glib
    gtk3
    wayland-scanner
  ];

  propagatedBuildInputs = [
    udev
  ];

  nativeCheckInputs = [
    check
    valgrind
  ];

  mesonFlags = [
    (mkFlag documentationSupport "documentation")
    (mkFlag eventGUISupport "debug-gui")
    (mkFlag testsSupport "tests")
    (mkFlag wacomSupport "libwacom")
    "--sysconfdir=/etc"
    "--libexecdir=${placeholder "bin"}/libexec"
  ];

  doCheck = testsSupport && stdenv.hostPlatform == stdenv.buildPlatform;

  doInstallCheck = true;

  postPatch = ''
    patchShebangs \
      test/symbols-leak-test \
      test/check-leftover-udev-rules.sh \
      test/helper-copy-and-exec-from-tmp.sh

    # Don't create an empty directory under /etc.
    sed -i "/install_emptydir(dir_etc \/ 'libinput')/d" meson.build
  '';

  passthru = {
    tests = {
      libinput-module = nixosTests.libinput;
    };
    updateScript = gitUpdater {
      patchlevel-unstable = true;
    };
  };

  meta = with lib; {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    mainProgram = "libinput";
    homepage = "https://www.freedesktop.org/wiki/Software/libinput/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ codyopel ];
    teams = [ teams.freedesktop ];
    changelog = "https://gitlab.freedesktop.org/libinput/libinput/-/releases/${version}";
    badPlatforms = [
      # Mandatory shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
}
