{ stdenv, fetchurl, tcl, openssl }:

stdenv.mkDerivation rec {
  name = "tcltls-${version}";
  version = "1.6.7";

  src = fetchurl {
    url = "mirror://sourceforge/tls/tls${version}-src.tar.gz";
    sha256 = "1f53sfcnrridjl5ayrq1xrqkahs8khf8c3d0m2brndbhahzdw6ai";
  };

  buildInputs = [ tcl openssl ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--with-ssl-dir=${openssl.dev}"
  ];

  preConfigure = ''
    configureFlags="--exec_prefix=$prefix $configureFlags"
  '';

  passthru = {
    libPrefix = "tls${version}";
  };

  meta = {
    homepage = http://tls.sourceforge.net/;
    description = "An OpenSSL / RSA-bsafe Tcl extension";
    license = stdenv.lib.licenses.tcltk;
    platforms = stdenv.lib.platforms.unix;
  };
}
