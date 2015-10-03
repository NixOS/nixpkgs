{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${gnome3.version}/${name}.tar.xz";
    sha256 = "0f0496nhirvpw4zk8bcl24rb2v20cm3gw8d5ybmch42mscmjrb0p";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mines;
    description = "Clear hidden mines from a minefield";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
