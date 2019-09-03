{ stdenv, fetchFromGitHub, pkgconfig, gdk-pixbuf, optipng, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "elementary-xfce-icon-theme";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${version}";
    sha256 = "16msdrazhbv80cvh5ffvgj13xmkpf87r7mq6xz071fza6nv7g0jn";
  };

  nativeBuildInputs = [ pkgconfig gdk-pixbuf librsvg optipng gtk3 hicolor-icon-theme ];

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
