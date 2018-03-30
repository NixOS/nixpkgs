{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

let
  pname = "gnome-themes-extra";
  version = "3.28";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "06aqg9asq2vqi9wr29bs4v8z2bf4manhbhfghf4nvw01y2zs0jvw";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ gtk3 librsvg pango atk gtk2 gdk_pixbuf gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
