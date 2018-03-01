{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib, json-glib
, gobjectIntrospection, liboauth, gnome3, p11-kit, openssl, uhttpmock }:

let
  majorVersion = "0.17";
in
stdenv.mkDerivation rec {
  name = "libgdata-${majorVersion}.9";

  src = fetchurl {
    url = "mirror://gnome/sources/libgdata/${majorVersion}/${name}.tar.xz";
    sha256 = "0fj54yqxdapdppisqm1xcyrpgcichdmipq0a0spzz6009ikzgi45";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.libsoup.dev}/include/libsoup-gnome-2.4/ -I${gnome3.gcr}/include/gcr-3 -I${gnome3.gcr}/include/gck-1";

  buildInputs = with gnome3;
    [ pkgconfig libsoup intltool libxml2 glib gobjectIntrospection
      liboauth gcr gnome-online-accounts p11-kit openssl uhttpmock ];

  propagatedBuildInputs = [ json-glib ];

  meta = with stdenv.lib; {
    description = "GData API library";
    maintainers = with maintainers; [ raskin lethalman ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };

}
