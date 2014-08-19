{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib
, gobjectIntrospection, liboauth, gnome3, p11_kit, openssl }:

stdenv.mkDerivation rec {
  name = "libgdata-0.14.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgdata/0.14/${name}.tar.xz";
    sha256 = "1scjs944kjazbsh86kdj6w2vprib6yd3wzxzabcs59acmr0m4hax";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.libsoup}/include/libsoup-gnome-2.4/ -I${gnome3.gcr}/include/gcr-3 -I${gnome3.gcr}/include/gck-1";

  buildInputs = with gnome3;
    [ pkgconfig libsoup intltool libxml2 glib gobjectIntrospection
      liboauth gcr gnome_online_accounts p11_kit openssl ];
      
  meta = with stdenv.lib; {
    description = "GData API library";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };

}
