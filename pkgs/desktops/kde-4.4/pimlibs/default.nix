{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdepimlibs-4.4.5.tar.bz2;
    sha256 = "06ibdg8cxhc9p4ywxa8f7kb0bnv0789qiapifvdfdr3zc8m0nj24";
  };
  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme stdenv.gcc.libc libical openldap shared_mime_info
                  kdelibs automoc4 phonon akonadi ];
  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
