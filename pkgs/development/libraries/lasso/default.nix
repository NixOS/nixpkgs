{ stdenv, autoconf, automake, autoreconfHook, fetchurl, glib, gobjectIntrospection, gtk-doc, libtool, libxml2, libxslt, openssl, pkgconfig, python27Packages, xmlsec, zlib }:

stdenv.mkDerivation rec {

  name = "lasso-${version}";
  version = "2.5.1";

  src = fetchurl {
    url = "https://dev.entrouvert.org/lasso/lasso-${version}.tar.gz";
    sha256 = "0n10zjjw84303c9vfy9bqhyzdl01459akbwy86cbgphd826mq45y";

  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ autoconf automake glib gobjectIntrospection gtk-doc libtool libxml2 libxslt openssl python27Packages.six xmlsec zlib ];

  configurePhase = ''
    ./configure --with-pkg-config=$PKG_CONFIG_PATH \
                --disable-python \
                --disable-perl \
                --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://lasso.entrouvert.org/;
    description = "Liberty Alliance Single Sign-On library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };

}
