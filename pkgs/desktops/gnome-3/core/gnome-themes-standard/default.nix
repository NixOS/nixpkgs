{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-${version}";
  version = "3.22.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "61dc87c52261cfd5b94d65e8ffd923ddeb5d3944562f84942eeeb197ab8ab56a";
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
