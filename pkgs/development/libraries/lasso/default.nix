{ stdenv, autoconf, automake, autoreconfHook, fetchurl, glib, gobject-introspection, gtk-doc, libtool, libxml2, libxslt, openssl, pkgconfig, python27Packages, xmlsec, zlib }:

stdenv.mkDerivation rec {

  name = "lasso-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "https://dev.entrouvert.org/lasso/lasso-${version}.tar.gz";
    sha256 = "1kqagm63a4mv5sw5qc3y0qlky7r9qg5lccq0c3cnfr0n4mxgysql";

  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ autoconf automake glib gobject-introspection gtk-doc libtool libxml2 libxslt openssl python27Packages.six xmlsec zlib ];

  configurePhase = ''
    ./configure --with-pkg-config=$PKG_CONFIG_PATH \
                --disable-python \
                --disable-perl \
                --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://lasso.entrouvert.org/;
    description = "Liberty Alliance Single Sign-On library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };

}
