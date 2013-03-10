{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, useGnupg1 ? false, gnupg1 ? null }:

assert useGnupg1 -> gnupg1 != null;
assert !useGnupg1 -> gnupg != null;

let
  gpgPath = if useGnupg1 then
    "${gnupg1}/bin/gpg"
  else
    "${gnupg}/bin/gpg2";
in
stdenv.mkDerivation rec {
  name = "gpgme-1.3.1";
  
  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/gpgme/${name}.tar.bz2";
    sha256 = "1m7l7nicn6gd952cgspv9xr8whqivbg33nbg8kbpj3dffnl2gvqm";
  };
  
  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--with-gpg=${gpgPath}";
}
