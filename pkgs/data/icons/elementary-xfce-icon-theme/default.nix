{ stdenv, fetchFromGitHub, pkgconfig, gdk_pixbuf, optipng, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "elementary-xfce-icon-theme-${version}";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${version}";
    sha256 = "01hlpw4vh4kgyghki01jp0snbn0g79mys28fb1m993mivnlzmn75";
  };

  nativeBuildInputs = [ pkgconfig gdk_pixbuf librsvg optipng gtk3 hicolor-icon-theme ];

  postPatch = ''
    substituteInPlace svgtopng/Makefile --replace "-O0" "-O"
  '';

  postInstall = ''
    make icon-caches
  '';

  meta = with stdenv.lib; {
    description = "Elementary icons for Xfce and other GTK+ desktops like GNOME";
    homepage = https://github.com/shimmerproject/elementary-xfce;
    license = licenses.gpl2;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
