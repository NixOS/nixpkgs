{stdenv, fetchurl, pkgconfig, gtk, mono, gtk-sharp, gnome}:

stdenv.mkDerivation {
  name = "gnome-sharp-2.24.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/gnome-sharp/2.24/gnome-sharp-2.24.1.tar.gz;
    sha256 = "0cfvs7hw67fp0wimskqd0gdfx323gv6hi0c5pf59krnmhdrl6z8p";
  };

  buildInputs = [ pkgconfig gtk mono gtk-sharp ]
  ++ (with gnome; [ libart_lgpl gnome_vfs libgnome libgnomecanvas libgnomeui]);

  patches = [ ./Makefile.in.patch ];

  meta = with stdenv.lib; {
    homepage = http://www.mono-project.com/docs/gui/gtksharp/;
    description = "A .NET language binding for assorted GNOME libraries";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
