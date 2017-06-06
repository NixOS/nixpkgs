{stdenv, fetchurl, fetchFromGitHub, dmd, pango, atk,  gdk_pixbuf, gnome3, gstreamer, gtk3, glibc , pkgconfig }:

stdenv.mkDerivation rec {
  name = "gtkd";
  version = "3.3.1";
  buildInputs = [ dmd pango atk  gdk_pixbuf gstreamer gtk3 gnome3.gtksourceview glibc pkgconfig ];

   src = fetchFromGitHub {
     owner = "gtkd-developers";
     repo = "GtkD";
     rev = "v${version}";
     md5 = "1a6bb6fa3763d67e200dd269eb264f3b";
   };

  preConfigure = ''cd ${src}'';

  makeFlags = ''
    "PREFIX=$out/usr"

    "DESTDIR="${src}/"
  '';

  buildPhase = ''
    mkdir -p $out/usr
    mkdir -p $out/lib
    make DC='ldconfig' all
  '';

  installPhase = ''
    make ${makeFlags} install \
    install-vte install-shared install-shared-vte
  '';

  meta = {
    description = ''D bindings for GTK+ and related libraries'';
    license = stdenv.lib.licenses.lgpl2 ;
    platforms = stdenv.lib.platforms.linux;
  };
}
