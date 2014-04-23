{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libsoup, json_glib, gmp, openssl }:

stdenv.mkDerivation rec {
  name = "gnome-online-miners-3.10.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/3.10/${name}.tar.xz";
    sha256 = "129807d398e7744870110e6875629b6858d289021271550569ce5afa10fe9ea8";
  };

  doCheck = true;

  buildInputs = [ pkgconfig glib gnome3.libgdata libxml2 libsoup gmp openssl
                  gnome3.grilo gnome3.libzapojit gnome3.gnome_online_accounts
                  gnome3.tracker gnome3.gfbgraph json_glib gnome3.rest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeOnlineMiners;
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
