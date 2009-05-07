{stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap,
 kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdepimlibs-4.2.3.tar.bz2;
    sha1 = "3b12d5974bfbc384e3c986328a7bb5b1b6b50361";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap
                  kdelibs automoc4 phonon akonadi ];
}
