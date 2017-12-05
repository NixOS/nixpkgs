{ stdenv, fetchurl, pkgconfig, gtk3, glibmm, cairomm, pangomm, atkmm, epoxy }:

let
  ver_maj = "3.22";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gtkmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${ver_maj}/${name}.tar.xz";
    sha256 = "05da4d4b628fb20c8384630ddf478a3b5562952b2d6181fe28d58f6cbc0514f5";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ epoxy ];

  propagatedBuildInputs = [ glibmm gtk3 atkmm cairomm pangomm ];

  enableParallelBuilding = true;

  # https://bugzilla.gnome.org/show_bug.cgi?id=764521
  doCheck = false;

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

    homepage = https://gtkmm.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin vcunat ];
    platforms = platforms.unix;
  };
}
