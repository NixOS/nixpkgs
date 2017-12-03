{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection, gnome3 }:

stdenv.mkDerivation rec {
  name = "rest-${version}";
  major = "0.8";
  version = "${major}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/rest/${major}/${name}.tar.xz";
    sha256 = "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libsoup gobjectIntrospection];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
