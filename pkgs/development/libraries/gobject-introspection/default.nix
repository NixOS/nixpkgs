{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gobject-introspection-1.34.2";

  buildInputs = [ flex bison glib pkgconfig python gdk_pixbuf ];
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/1.34/${name}.tar.xz";
    sha256 = "0a9lq0y67sr3g37l1hy0biqn046jr9wnd05hvwi8j8g2bjilhydw";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
}
