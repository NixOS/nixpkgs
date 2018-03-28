{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

let
  pname = "gnome-themes-extra";
  version = "3.27.92";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "04jwsg9f29vzhcmf146d3rr27c8ldra378m465ahsal9vaaiywcm";
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
