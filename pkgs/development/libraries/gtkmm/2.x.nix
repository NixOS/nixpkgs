{ lib, stdenv, fetchurl, pkg-config, gtk2, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = "gtkmm-${minVer}.5";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${minVer}/${name}.tar.xz";
    sha256 = "0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ glibmm gtk2 atkmm cairomm pangomm ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "C++ interface to the GTK graphical user interface library";

    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';

    homepage = "https://gtkmm.org/";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ raskin vcunat ];
    platforms = lib.platforms.unix;
  };
}
