{ lib
, stdenv
, fetchurl
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
    python3.pkgs.sphinx.overrideAttrs (attrs: {
      propagatedBuildInputs =
        attrs.propagatedBuildInputs
        ++ (with python3.pkgs; [
          recommonmark
          sphinx_rtd_theme
        ]);

      postFixup = attrs.postFixup or "" + ''
        # Do not propagate Python
        rm $out/nix-support/propagated-build-inputs
      '';
    });
in

stdenv.mkDerivation rec {
  pname = "libinput";
  version = "1.19.3";

  outputs = [ "bin" "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libinput/libinput-${version}.tar.xz";
    sha256 = "sha256-PK54zN4Z19Dzh+WLxzTU0Xq19kJvVKnotyjJCxe6oGg=";
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

  checkInputs = [
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

  passthru.tests = {
    libinput-module = nixosTests.libinput;
  };

  meta = with lib; {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage = "https://www.freedesktop.org/wiki/Software/libinput/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ] ++ teams.freedesktop.members;
  };
}
