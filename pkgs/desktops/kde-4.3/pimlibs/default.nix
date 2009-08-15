{stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap,
 kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdepimlibs-4.2.4.tar.bz2;
    sha1 = "1deb9298fe935ed1a53fad8e2a060fdc1c3e4ad8";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap
                  kdelibs automoc4 phonon akonadi ];
}
