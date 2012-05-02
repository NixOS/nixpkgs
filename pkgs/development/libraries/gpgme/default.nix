{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan }:

stdenv.mkDerivation rec {
  name = "gpgme-1.3.1";
  
  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/gpgme/${name}.tar.bz2";
    sha256 = "1m7l7nicn6gd952cgspv9xr8whqivbg33nbg8kbpj3dffnl2gvqm";
  };
  
  propagatedBuildInputs = [ libgpgerror glib pth libassuan ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = "--with-gpg=${gnupg}/bin/gpg2";
}
