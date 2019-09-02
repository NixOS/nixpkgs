{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libgdata, grilo, libzapojit, grilo-plugins, gnome-online-accounts, libmediaart
, tracker, gfbgraph, librest, libsoup, json-glib, gmp, openssl, dleyna-server, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gnome-online-miners";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0pjamwwzn5wqgihyss357dyl2q70r0bngnqmwsqawchx5f9aja9c";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    glib libgdata libxml2 libsoup gmp openssl
    grilo libzapojit grilo-plugins
    gnome-online-accounts libmediaart
    tracker gfbgraph json-glib librest
    dleyna-server
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-online-miners";
      attrPath = "gnome3.gnome-online-miners";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeOnlineMiners;
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
