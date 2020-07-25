{ stdenv, fetchurl, pkgconfig, meson, ninja
, libevdev, mtdev, udev, libwacom
, documentationSupport ? false, doxygen ? null, graphviz ? null # Documentation
, eventGUISupport ? false, cairo ? null, glib ? null, gtk3 ? null # GUI event viewer support
, testsSupport ? false, check ? null, valgrind ? null, python3 ? null
}:

assert documentationSupport -> doxygen != null && graphviz != null && python3 != null;
assert eventGUISupport -> cairo != null && glib != null && gtk3 != null;
assert testsSupport -> check != null && valgrind != null && python3 != null;

let
  mkFlag = optSet: flag: "-D${flag}=${stdenv.lib.boolToString optSet}";

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

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libinput";
  version = "1.15.5";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libinput/${pname}-${version}.tar.xz";
    sha256 = "15ww4jl3lcxyi8m8idg8canklbqv729gnwpkz7r98c1w8a7zq3m9";
  };

  outputs = [ "bin" "out" "dev" ];

  mesonFlags = [
    (mkFlag documentationSupport "documentation")
    (mkFlag eventGUISupport "debug-gui")
    (mkFlag testsSupport "tests")
    "--sysconfdir=/etc"
    "--libexecdir=${placeholder "bin"}/libexec"
  ];

  nativeBuildInputs = [ pkgconfig meson ninja ]
    ++ optionals documentationSupport [ doxygen graphviz sphinx-build ];

  buildInputs = [ libevdev mtdev libwacom ]
    ++ optionals eventGUISupport [ cairo glib gtk3 ];

  checkInputs = [ (python3.withPackages (pkgs: with pkgs; [ evdev ])) check valgrind ];

  propagatedBuildInputs = [ udev ];

  patches = [ ./udev-absolute-path.patch ];

  postPatch = ''
    patchShebangs tools/helper-copy-and-exec-from-tmp.sh
    patchShebangs test/symbols-leak-test
    patchShebangs test/check-leftover-udev-rules.sh
  '';

  doCheck = testsSupport && stdenv.hostPlatform == stdenv.buildPlatform;

  meta = {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage    = "http://www.freedesktop.org/wiki/Software/libinput";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
