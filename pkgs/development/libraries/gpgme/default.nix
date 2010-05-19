{stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth}:

stdenv.mkDerivation {
  name = "gpgme-1.1.4";
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.1.4.tar.bz2;
    sha256 = "0ncrv7p33rjq1avkxpp9x0gz6wna9y3b3dmw6nv366n5mgvxmpg8";
  };
  buildInputs = [libgpgerror gnupg pkgconfig glib pth];
}
