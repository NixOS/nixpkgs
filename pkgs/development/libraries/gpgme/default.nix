{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan }:

stdenv.mkDerivation rec {
  name = "gpgme-1.3.0";
  
  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/gpgme/${name}.tar.bz2";
    sha256 = "18g6wgiacnbj437yfsczbjxaf041ljia48dnv2qgcqb0sky41q3l";
  };
  
  propagatedBuildInputs = [ libgpgerror glib pth libassuan ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = "--with-gpg=${gnupg}/bin/gpg2";
}
