{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-chess-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "a0f6f862ab7067626a3a86cdc9c14dde595e38e6719e0198cb967e11facf1f12";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-chess"; attrPath = "gnome3.gnome-chess"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool librsvg libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Chess;
    description = "Play the classic two-player boardgame of chess";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
