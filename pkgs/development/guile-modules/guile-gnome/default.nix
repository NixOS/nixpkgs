{ lib
, stdenv
, fetchurl
, gconf
, glib
, gnome_vfs
, gtk2
, guile
, guile-cairo
, guile-lib
, gwrap
, libglade
, libgnome
, libgnomecanvas
, libgnomeui
, pango
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-gnome-platform";
  version = "2.16.4";

  src = fetchurl {
    url = "mirror://gnu/guile-gnome/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-ravUjtWZPYUo/WBOCqDZatgaYdBtps3WgyNXKtbCFsM=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo
  ];
  buildInputs = [
    gconf
    glib
    gnome_vfs
    gtk2
    guile
    guile-cairo
    gwrap
    libglade
    libgnome
    libgnomecanvas
    libgnomeui
    pango
  ] ++ lib.optional doCheck guile-lib;

  # The test suite tries to open an X display, which fails.
  doCheck = false;

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-gnome/";
    description = "GNOME bindings for GNU Guile";
    longDescription = ''
      GNU guile-gnome brings the power of Scheme to your graphical application.
      guile-gnome modules support the entire Gnome library stack: from Pango to
      GnomeCanvas, GTK to GStreamer, Glade to GtkSourceView, you will find in
      guile-gnome a comprehensive environment for developing modern
      applications.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
