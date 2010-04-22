{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdepimlibs-4.4.2.tar.bz2;
    sha256 = "071rxf3ym3yf4klzy5dcvrppfm6lm8lhfphidgq97in322g76kl8";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap shared_mime_info
                  kdelibs automoc4 phonon akonadi ];
  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
