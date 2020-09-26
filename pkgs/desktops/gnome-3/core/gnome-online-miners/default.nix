{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libgdata, grilo, libzapojit, grilo-plugins, gnome-online-accounts, libmediaart
, tracker_2, gfbgraph, librest, libsoup, json-glib, gmp, openssl, dleyna-server, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gnome-online-miners";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1n2jz9i8a42zwxx5h8j2gdy6q1vyydh4vl00r0al7w8jzdh24p44";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    glib libgdata libxml2 libsoup gmp openssl
    grilo libzapojit grilo-plugins
    gnome-online-accounts libmediaart
    tracker_2 gfbgraph json-glib librest
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
    homepage = "https://wiki.gnome.org/Projects/GnomeOnlineMiners";
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
