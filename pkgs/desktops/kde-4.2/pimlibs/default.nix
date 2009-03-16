{stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap,
 kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdepimlibs-4.2.1.tar.bz2;
    sha1 = "150228037fcd740fec0a490149cd1980ddb8fb57";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap
                  kdelibs automoc4 phonon akonadi ];
}
