{ lib, stdenv, fetchurl, pkg-config, meson, ninja
, libevdev, mtdev, udev, libwacom
, documentationSupport ? false, doxygen, graphviz # Documentation
, eventGUISupport ? false, cairo, glib, gtk3 # GUI event viewer support
, testsSupport ? false, check, valgrind, python3
}:

let
  mkFlag = optSet: flag: "-D${flag}=${lib.boolToString optSet}";

  sphinx-build = if documentationSupport then
    python3.pkgs.sphinx.overrideAttrs (super: {
      propagatedBuildInputs = super.propagatedBuildInputs ++ (with python3.pkgs; [ recommonmark sphinx_rtd_theme ]);

      postFixup = super.postFixup or "" + ''
        # Do not propagate Python
        rm $out/nix-support/propagated-build-inputs
      '';
    })
  else null;
in

stdenv.mkDerivation rec {
  pname = "libinput";
  version = "1.19.1";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libinput/libinput-${version}.tar.xz";
    sha256 = "sha256-C9z1sXg7c3hUt68coi32e8Nqb+fJz6cfAekUn5IgRG0=";
  };

  outputs = [ "bin" "out" "dev" ];

  mesonFlags = [
    (mkFlag documentationSupport "documentation")
    (mkFlag eventGUISupport "debug-gui")
    (mkFlag testsSupport "tests")
    "--sysconfdir=/etc"
    "--libexecdir=${placeholder "bin"}/libexec"
  ];

  nativeBuildInputs = [ pkg-config meson ninja ]
    ++ lib.optionals documentationSupport [ doxygen graphviz sphinx-build ];

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
  ] ++ lib.optionals eventGUISupport [ cairo glib gtk3 ];

  checkInputs = [
    check
    valgrind
  ];

  propagatedBuildInputs = [ udev ];

  patches = [ ./udev-absolute-path.patch ];

  postPatch = ''
    patchShebangs \
      tools/helper-copy-and-exec-from-tmp.sh \
      test/symbols-leak-test \
      test/check-leftover-udev-rules.sh \
      test/helper-copy-and-exec-from-tmp.sh

    # Don't create an empty /etc directory.
    sed -i "/install_subdir('libinput', install_dir : dir_etc)/d" meson.build
  '';

  doCheck = testsSupport && stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with lib; {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage    = "https://www.freedesktop.org/wiki/Software/libinput/";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
