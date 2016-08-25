{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib, json_glib
, gobjectIntrospection, liboauth, gnome3, p11_kit, openssl, uhttpmock }:

let
  majorVersion = "0.17";
in
stdenv.mkDerivation rec {
  name = "libgdata-${majorVersion}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libgdata/${majorVersion}/${name}.tar.xz";
    sha256 = "1xniw4y90hbk9fa548pa9pfclibw7amr2f458lfh16jdzq7gw5cz";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.libsoup.dev}/include/libsoup-gnome-2.4/ -I${gnome3.gcr}/include/gcr-3 -I${gnome3.gcr}/include/gck-1";

  buildInputs = with gnome3;
    [ pkgconfig libsoup intltool libxml2 glib gobjectIntrospection
      liboauth gcr gnome_online_accounts p11_kit openssl uhttpmock ];

  propagatedBuildInputs = [ json_glib ];

  meta = with stdenv.lib; {
    description = "GData API library";
    maintainers = with maintainers; [ raskin lethalman ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };

}
