{ stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation rec {
  name = "kdepimlibs-4.4.92";

  src = fetchurl {
    url = "mirror://kde/unstable/4.4.92/src/${name}.tar.bz2";
    sha256 = "08y1fvacahv565vfvjjkg10cg660zbfqbqi8n280nxz73qgjmlj7";
  };

  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme libical openldap
    shared_mime_info kdelibs automoc4 phonon akonadi ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers;
  };
}
