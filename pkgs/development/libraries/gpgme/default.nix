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
  name = "gpgme-1.5.2";

  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/gpgme/${name}.tar.bz2";
    sha256 = "1m7i0krffw4717jx7211d0pk4wi2rldg2bp7xgl6a0kgl6hb160y";
  };

  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = "--with-gpg=${gpgPath}";

  meta = {
    homepage = "http://www.gnupg.org/related_software/gpgme";
    description = "Library for making GnuPG easier to use";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
