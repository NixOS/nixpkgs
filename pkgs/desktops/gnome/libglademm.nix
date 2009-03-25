{ fetchurl, stdenv, pkgconfig, libglade, gtkmm }:

stdenv.mkDerivation rec {
  name = "libglademm-2.6.7";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/${name}.tar.bz2";
    sha256 = "1hrbg9l5qb7w0xvr7013qamkckyj0fqc426c851l69zpmhakqm1q";
  };

  buildInputs = [ pkgconfig libglade gtkmm ];

  meta = {
    description = "C++ interface to the libglade graphical user interface library";

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

    license = "LGPLv2+";
  };
}
