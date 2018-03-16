{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-${version}";
  version = "3.27.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1p1ibm0f2py0lrxrw8wv1jvs630mmz9q97f404jyzr4a8nswrizz";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-themes-standard"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk3 librsvg pango atk gtk2 gdk_pixbuf
                  gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
