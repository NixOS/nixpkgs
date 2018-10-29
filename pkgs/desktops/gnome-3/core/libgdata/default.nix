{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib, json-glib
, gobjectIntrospection, liboauth, gnome3, p11-kit, openssl, uhttpmock }:

let
  pname = "libgdata";
  version = "0.17.9";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0fj54yqxdapdppisqm1xcyrpgcichdmipq0a0spzz6009ikzgi45";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.libsoup.dev}/include/libsoup-gnome-2.4/ -I${gnome3.gcr}/include/gcr-3 -I${gnome3.gcr}/include/gck-1";

  buildInputs = with gnome3;
    [ pkgconfig libsoup intltool libxml2 glib gobjectIntrospection
      liboauth gcr gnome-online-accounts p11-kit openssl uhttpmock ];

  propagatedBuildInputs = [ json-glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none"; # Stable version has not been updated for a long time.
    };
  };

  meta = with stdenv.lib; {
    description = "GData API library";
    homepage = https://wiki.gnome.org/Projects/libgdata;
    maintainers = with maintainers; [ raskin lethalman ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };

}
