{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, gdk_pixbuf
, libintlOrEmpty, autoconf, automake, otool }:

stdenv.mkDerivation rec {
  name = "gobject-introspection-1.34.2";

  buildInputs = [ flex bison glib pkgconfig python gdk_pixbuf ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin otool;
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = [ "--disable-tests" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/1.34/${name}.tar.xz";
    sha256 = "0a9lq0y67sr3g37l1hy0biqn046jr9wnd05hvwi8j8g2bjilhydw";
  };

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage    = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ lovek323 urkud ];
    platforms   = platforms.unix;

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
}
