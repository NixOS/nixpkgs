{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdepimlibs-4.3.5.tar.bz2;
    sha256 = "05sygbx2svhxfarywaw1cj7j3v9yaq9fnsrvizv3vibw8g0csyvn";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap shared_mime_info
                  kdelibs automoc4 phonon akonadi ];
  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
