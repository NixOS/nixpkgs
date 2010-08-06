{ stdenv, fetchurl, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, akonadi, soprano}:

stdenv.mkDerivation rec {
  name = "kdepimlibs-4.4.95";

  src = fetchurl {
    url = "mirror://kde/unstable/4.4.95/src/${name}.tar.bz2";
    sha256 = "06ap22p9x7l698skkrnsh7k3h1z0v6h3h3fwjrv4y6lv5vygccny";
  };

  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme libical openldap
    shared_mime_info kdelibs automoc4 akonadi soprano ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers;
  };
}
