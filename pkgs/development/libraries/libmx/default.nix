{ lib, stdenv, fetchFromGitHub
, libtool, pkg-config, automake, autoconf, intltool
, glib, gobject-introspection, gtk2, gtk-doc
, clutter, clutter-gtk
}:

stdenv.mkDerivation rec {
  pname = "libmx";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "clutter-project";
    repo = "mx";
    rev = version;
    sha256 = "sha256-+heIPSkg3d22xsU48UOTJ9FPLXC7zLivcnabQOM9aEk=";
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

  nativeBuildInputs = [ pkg-config automake autoconf intltool gobject-introspection ];
  buildInputs = [
    libtool
    gtk2 gtk-doc clutter clutter-gtk
  ];

  # patch to resolve GL errors
  # source : https://github.com/clutter-project/mx/pull/62
  preBuild = ''
    sed -i 's/GLushort/gushort/g' mx/mx-deform-texture.c
    sed -i 's/GLfloat/gfloat/g' mx/mx-texture-frame.c
  '';

  meta = with lib; {
    homepage = "http://www.clutter-project.org/";
    description = "Clutter-based toolkit";
    mainProgram = "mx-create-image-cache";
    longDescription =
      ''Mx is a widget toolkit using Clutter that provides a set of standard
        interface elements, including buttons, progress bars, scroll bars and
        others. It also implements some standard managers. One other interesting
        feature is the possibility setting style properties from a CSS format
        file.'';
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
