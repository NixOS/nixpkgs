{ stdenv, fetchurl, pkgconfig, gnome3, intltool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "libpeas-${version}";
  version = "1.9.0";

  buildInputs = with gnome3; [ intltool pkgconfig glib gobjectIntrospection gtk3 ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/1.9/${name}.tar.xz";
    sha256 = "13fzyzv6c0cfdj83z1s16lv8k997wpnzyzr0wfwcfkcmvz64g1q0";
  };

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
