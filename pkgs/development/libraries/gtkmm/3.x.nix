{ stdenv, fetchurl, pkgconfig, gtk3, glibmm, cairomm, pangomm, atkmm, epoxy }:

let
  ver_maj = "3.18";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gtkmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${ver_maj}/${name}.tar.xz";
    sha256 = "829fa113daed74398c49c3f2b7672807f58ba85d0fa463f5bc726e1b0138b86b";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ epoxy ];

  propagatedBuildInputs = [ glibmm gtk3 atkmm cairomm pangomm ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "C++ interface to the GTK+ graphical user interface library";

    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK+.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';

    homepage = http://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin vcunat ];
    platforms = platforms.unix;
  };
}
