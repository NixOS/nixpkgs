{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gtk-doc,
  autoconf,
  automake,
  which,
  libtool,
  gobject-introspection,
  glib,
  gtk2,
  libGLU,
  libGL,
  pango,
  xorg,
}:

stdenv.mkDerivation {
  pname = "gtkglext";
  version = "unstable-2019-12-19";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gtkglext";
    # build fixes
    # https://gitlab.gnome.org/Archive/gtkglext/merge_requests/1
    rev = "ad95fbab68398f81d7a5c895276903b0695887e2";
    sha256 = "1d1bp4635nla7d07ci40c7w4drkagdqk8wg93hywvdipmjfb4yqb";
  };

  nativeBuildInputs = [
    pkg-config
    gtk-doc
    autoconf
    automake
    which
    libtool
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk2
    libGLU
    libGL
    pango
    xorg.libX11
    xorg.libXmu
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://projects.gnome.org/gtkglext/";
    description = "GtkGLExt, an OpenGL extension to GTK";
    longDescription = ''
      GtkGLExt is an OpenGL extension to GTK. It provides additional GDK
      objects which support OpenGL rendering in GTK and GtkWidget API
      add-ons to make GTK widgets OpenGL-capable.  In contrast to Janne
      Löf's GtkGLArea, GtkGLExt provides a GtkWidget API that enables
      OpenGL drawing for standard and custom GTK widgets.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
