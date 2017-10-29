{ stdenv, fetchurl, pkgconfig, meson, ninja, libevdev, mtdev, udev, libwacom
, documentationSupport ? false, doxygen ? null, graphviz ? null # Documentation
, eventGUISupport ? false, cairo ? null, glib ? null, gtk3 ? null # GUI event viewer support
, testsSupport ? false, check ? null, valgrind ? null }:

assert documentationSupport -> doxygen != null && graphviz != null;
assert eventGUISupport -> cairo != null && glib != null && gtk3 != null;
assert testsSupport -> check != null && valgrind != null;

let mkFlag = c: flag: if c then "-D${flag}=true" else "-D${flag}=false";
in with stdenv.lib; stdenv.mkDerivation rec {
  name = "libinput-${version}";
  version = "1.8.2";

  src = fetchurl {
    url = "https://freedesktop.org/software/libinput/${name}.tar.xz";
    sha256 = "0f5brc28yww3nycm7nya703k4dr1pbpi517hw7k8f8nv1bp1hd81";
  };

  outputs = [ "out" "dev" ];
  
  mesonFlags = [
    (mkFlag documentationSupport "documentation")
    (mkFlag eventGUISupport "debug-gui")
    (mkFlag testsSupport "tests")
  ];

  patches = [ ./udev-absolute-path.patch ];
  
  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ libevdev mtdev libwacom ]
    ++ optionals eventGUISupport [ cairo glib gtk3 ]
    ++ optionals documentationSupport [ doxygen graphviz ]
    ++ optionals testsSupport [ check valgrind ];

  propagatedBuildInputs = [ udev ];

  meta = {
    description = "Handles input devices in Wayland compositors and provides a generic X.Org input driver";
    homepage    = http://www.freedesktop.org/wiki/Software/libinput;
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel wkennington ];
  };
}
