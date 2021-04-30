{ lib, stdenv, fetchurl, tcl, openssl }:

tcl.mkTclDerivation rec {
  pname = "tcltls";
  version = "1.6.7";

  src = fetchurl {
    url = "mirror://sourceforge/tls/tls${version}-src.tar.gz";
    sha256 = "1f53sfcnrridjl5ayrq1xrqkahs8khf8c3d0m2brndbhahzdw6ai";
  };

  buildInputs = [ openssl ];

  configureFlags = [
    "--with-ssl-dir=${openssl.dev}"
  ];

  meta = {
    homepage = "http://tls.sourceforge.net/";
    description = "An OpenSSL / RSA-bsafe Tcl extension";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
