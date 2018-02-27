{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libsoup, json-glib, gmp, openssl, dleyna-server, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ glib gnome3.libgdata libxml2 libsoup gmp openssl
                  gnome3.grilo gnome3.libzapojit gnome3.grilo-plugins
                  gnome3.gnome-online-accounts gnome3.libmediaart
                  gnome3.tracker gnome3.gfbgraph json-glib gnome3.rest
                  dleyna-server ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeOnlineMiners;
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
