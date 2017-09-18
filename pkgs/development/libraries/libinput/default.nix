{ stdenv, fetchurl, pkgconfig, meson, ninja
, libevdev, mtdev, udev, libwacom
, documentationSupport ? false, doxygen ? null, graphviz ? null # Documentation
, eventGUISupport ? false, cairo ? null, glib ? null, gtk3 ? null # GUI event viewer support
, testsSupport ? false, check ? null, valgrind ? null
}:

assert documentationSupport -> doxygen != null && graphviz != null;
assert eventGUISupport -> cairo != null && glib != null && gtk3 != null;
assert testsSupport -> check != null && valgrind != null;

let
  mkFlag = optSet: flag: "-D${flag}=${stdenv.lib.boolToString optSet}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libinput-${version}";
  version = "1.9.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "1y3559146zlfizncky1jlly226i66vwikxhpdkw0jg8v47j0sy7h";
  };

  outputs = [ "out" "dev" ];

  mesonFlags = [
    (mkFlag documentationSupport "documentation")
    (mkFlag eventGUISupport "debug-gui")
    (mkFlag testsSupport "tests")
  ];

  nativeBuildInputs = [ pkgconfig meson ninja ]
    ++ optionals documentationSupport [ doxygen graphviz ]
    ++ optionals testsSupport [ check valgrind ];

  buildInputs = [ libevdev mtdev libwacom ]
    ++ optionals eventGUISupport [ cairo glib gtk3 ];

  propagatedBuildInputs = [ udev ];

  patches = [ ./udev-absolute-path.patch ];

  meta = {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage    = http://www.freedesktop.org/wiki/Software/libinput;
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel wkennington ];
  };
}
