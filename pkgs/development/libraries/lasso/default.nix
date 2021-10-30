{ lib, stdenv, autoconf, automake, autoreconfHook, fetchurl, glib, gobject-introspection, gtk-doc, libtool, libxml2, libxslt, openssl, pkg-config, python27Packages, xmlsec, zlib }:

stdenv.mkDerivation rec {

  pname = "lasso";
  version = "2.7.0";

  src = fetchurl {
    url = "https://dev.entrouvert.org/lasso/lasso-${version}.tar.gz";
    sha256 = "138x8pmj4k1pbah32z14rd8ylyx4lgz70s93m39vd17f8sjz50lj";

  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ autoconf automake glib gobject-introspection gtk-doc libtool libxml2 libxslt openssl python27Packages.six xmlsec zlib ];

  configurePhase = ''
    ./configure --with-pkg-config=$PKG_CONFIG_PATH \
                --disable-python \
                --disable-perl \
                --prefix=$out
  '';

  meta = with lib; {
    homepage = "https://lasso.entrouvert.org/";
    description = "Liberty Alliance Single Sign-On library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };

}
