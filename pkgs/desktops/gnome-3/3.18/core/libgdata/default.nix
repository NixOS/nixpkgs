{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib, json_glib
, gobjectIntrospection, liboauth, gnome3, p11_kit, openssl }:

let
  majorVersion = "0.16";
in
stdenv.mkDerivation rec {
  name = "libgdata-${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgdata/${majorVersion}/${name}.tar.xz";
    sha256 = "8740e071ecb2ae0d2a4b9f180d2ae5fdf9dc4c41e7ff9dc7e057f62442800827";
  };

  # TODO: need libuhttpmock
  configureFlags = "--disable-tests";
  
  NIX_CFLAGS_COMPILE = "-I${gnome3.libsoup.dev}/include/libsoup-gnome-2.4/ -I${gnome3.gcr}/include/gcr-3 -I${gnome3.gcr}/include/gck-1";

  buildInputs = with gnome3;
    [ pkgconfig libsoup intltool libxml2 glib gobjectIntrospection 
      liboauth gcr gnome_online_accounts p11_kit openssl ];

  propagatedBuildInputs = [ json_glib ];
      
  meta = with stdenv.lib; {
    description = "GData API library";
    maintainers = with maintainers; [ raskin lethalman ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };

}
