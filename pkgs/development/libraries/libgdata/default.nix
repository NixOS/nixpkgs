{ stdenv, fetchurl, pkgconfig, intltool, libxml2, glib, json-glib, gcr
, gobject-introspection, liboauth, gnome3, p11-kit, openssl, uhttpmock }:

stdenv.mkDerivation rec {
  pname = "libgdata";
  version = "0.17.9";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fj54yqxdapdppisqm1xcyrpgcichdmipq0a0spzz6009ikzgi45";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];

  buildInputs = [ gnome3.libsoup libxml2 glib liboauth gcr gnome3.gnome-online-accounts p11-kit openssl uhttpmock ];

  propagatedBuildInputs = [ json-glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
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
