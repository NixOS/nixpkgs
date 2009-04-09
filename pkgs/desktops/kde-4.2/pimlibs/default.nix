{stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap,
 kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdepimlibs-4.2.2.tar.bz2;
    sha1 = "895ae97d393ec47386de71bbe76fb5a685d3850f";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap
                  kdelibs automoc4 phonon akonadi ];
}
