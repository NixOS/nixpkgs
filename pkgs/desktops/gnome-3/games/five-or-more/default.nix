{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "five-or-more-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1fy4a7qdjqvabm0cl45d6xlx6hy4paxvm0b2paifff73bl250d5c";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "five-or-more"; attrPath = "gnome3.five-or-more"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Five_or_more;
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
