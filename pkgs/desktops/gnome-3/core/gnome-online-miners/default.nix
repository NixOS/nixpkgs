{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libsoup, json-glib, gmp, openssl, dleyna-server, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-online-miners-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "7f404db5eccb87524a5dfcef5b6f38b11047b371081559afbe48c34dbca2a98e";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-online-miners"; attrPath = "gnome3.gnome-online-miners"; };
  };

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
