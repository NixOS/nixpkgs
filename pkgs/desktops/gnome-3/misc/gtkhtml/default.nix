{ stdenv, fetchurl, pkgconfig, gtk3, intltool
, gnome3, enchant, isocodes }:

stdenv.mkDerivation rec {
  name = "gtkhtml-${version}";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "ca3b6424fb2c7ac5d9cb8fdafb69318fa2e825c9cf6ed17d1e38d9b29e5606c3";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gtkhtml"; attrPath = "gnome3.gtkhtml"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 intltool gnome3.adwaita-icon-theme
                  gnome3.gsettings-desktop-schemas ];

  propagatedBuildInputs = [ enchant isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
