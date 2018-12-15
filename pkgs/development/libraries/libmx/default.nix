{ stdenv, fetchurl
, libtool, pkgconfig, automake, autoconf, intltool
, glib, gobject-introspection, gtk2, gtk-doc
, clutter, clutter-gtk
}:

stdenv.mkDerivation rec {
  name = "libmx-${version}";
  version = "1.4.7";

  src = fetchurl {
    url = "https://github.com/clutter-project/mx/archive/${version}.tar.gz";
    sha256 = "8a7514ea33c1dec7251d0141e24a702e7701dc9f00348cbcf1816925b7f74dbc";
  };

  # remove the following superfluous checks
  preConfigure = ''
    substituteInPlace "autogen.sh" \
      --replace '`which intltoolize`' '"x"' \
      --replace '`which gtkdocize`' '"x"' \
      --replace '`which autoreconf`' '"x"'
  '';

  configureFlags = [ "--enable-introspection"
                     "--without-startup-notification"
                     "--without-dbus"
                     "--without-glade"
                     "--without-clutter-imcontext"
                     "--without-clutter-gesture"
                   ];

  configureScript = "sh autogen.sh";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    automake autoconf libtool
    intltool
    gobject-introspection glib
    gtk2 gtk-doc clutter clutter-gtk
  ];

  # patch to resolve GL errors
  # source : https://github.com/clutter-project/mx/pull/62
  preBuild = ''
    sed -i 's/GLushort/gushort/g' mx/mx-deform-texture.c
    sed -i 's/GLfloat/gfloat/g' mx/mx-texture-frame.c
  '';

  meta = with stdenv.lib; {
    homepage = http://www.clutter-project.org/;
    description = "A Clutter-based toolkit";
    longDescription =
      ''Mx is a widget toolkit using Clutter that provides a set of standard
        interface elements, including buttons, progress bars, scroll bars and
        others. It also implements some standard managers. One other interesting
        feature is the possibility setting style properties from a CSS format
        file.'';
    license = licenses.lgpl21;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; linux;
  };
}
