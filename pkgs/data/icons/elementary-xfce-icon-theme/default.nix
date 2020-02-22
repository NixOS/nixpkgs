{ stdenv, fetchFromGitHub, pkgconfig, gdk-pixbuf, optipng, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "elementary-xfce-icon-theme";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${version}";
    sha256 = "00sk6sv0kkfb3q0jqwcllzawi30rw8nfkkfn5l1qwqha48izw3r4";
  };

  nativeBuildInputs = [ pkgconfig gdk-pixbuf librsvg optipng gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    substituteInPlace svgtopng/Makefile --replace "-O0" "-O"
  '';

  postInstall = ''
    make icon-caches
  '';

  meta = with stdenv.lib; {
    description = "Elementary icons for Xfce and other GTK desktops like GNOME";
    homepage = https://github.com/shimmerproject/elementary-xfce;
    license = licenses.gpl2;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
