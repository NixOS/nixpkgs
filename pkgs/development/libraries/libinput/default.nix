{ lib
, stdenv
, fetchFromGitLab
, gitUpdater
, pkg-config
, meson
, ninja
, libevdev
, mtdev
, udev
, libwacom
, documentationSupport ? false
, doxygen
, graphviz
, runCommand
, eventGUISupport ? false
, cairo
, glib
, gtk3
, testsSupport ? false
, check
, valgrind
, python3
, nixosTests
}:

let
  mkFlag = optSet: flag: "-D${flag}=${lib.boolToString optSet}";

  sphinx-build =
    let
      env = python3.withPackages (pp: with pp; [
        sphinx
        recommonmark
        sphinx-rtd-theme
      ]);
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
  version = "1.21.0";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libinput";
    repo = "libinput";
    rev = version;
    sha256 = "R94BdrjI4szNbVtQ+ydRNUg9clR8mkRL7+GE9b2FcDs=";
  };

  patches = [
    ./udev-absolute-path.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ] ++ lib.optionals documentationSupport [
    doxygen
    graphviz
    sphinx-build
  ];

  buildInputs = [
    libevdev
    mtdev
    libwacom
    (python3.withPackages (pp: with pp; [
      pp.libevdev # already in scope
      pyudev
      pyyaml
      setuptools
    ]))
  ] ++ lib.optionals eventGUISupport [
    # GUI event viewer
    cairo
    glib
    gtk3
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
    "--sysconfdir=/etc"
    "--libexecdir=${placeholder "bin"}/libexec"
  ];

  doCheck = testsSupport && stdenv.hostPlatform == stdenv.buildPlatform;

  postPatch = ''
    patchShebangs \
      test/symbols-leak-test \
      test/check-leftover-udev-rules.sh \
      test/helper-copy-and-exec-from-tmp.sh

    # Don't create an empty /etc directory.
    sed -i "/install_subdir('libinput', install_dir : dir_etc)/d" meson.build
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
    homepage = "https://www.freedesktop.org/wiki/Software/libinput/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ] ++ teams.freedesktop.members;
  };
}
