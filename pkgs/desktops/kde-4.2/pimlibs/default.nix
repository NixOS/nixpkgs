{stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap,
 kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdepimlibs-4.2.0.tar.bz2;
    md5 = "8a91677e2dca7d4db26b33c78e239e5e";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap
                  kdelibs automoc4 phonon akonadi ];
}
