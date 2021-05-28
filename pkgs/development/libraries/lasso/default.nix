{ stdenv, autoconf, automake, autoreconfHook, fetchurl, glib, gobject-introspection, gtk-doc, libtool, libxml2, libxslt, openssl, pkgconfig, python27Packages, xmlsec, zlib }:

stdenv.mkDerivation rec {

  pname = "lasso";
  version = "2.6.1";

  src = fetchurl {
    url = "https://dev.entrouvert.org/lasso/lasso-${version}.tar.gz";
    sha256 = "1pniisy4z9cshf6lvlz28kfa3qnwnhldb2rvkjxzc0l84g7dpa7q";

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
    homepage = "https://lasso.entrouvert.org/";
    description = "Liberty Alliance Single Sign-On library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };

}
