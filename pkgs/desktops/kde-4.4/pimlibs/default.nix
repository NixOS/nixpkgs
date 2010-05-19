{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, phonon, akonadi}:

stdenv.mkDerivation {
  name = "kdepimlibs-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdepimlibs-4.4.3.tar.bz2;
    sha256 = "1q95zwkncady9lviz7bs9pnp1fkqlmnp33vj446m3krwjdh19b4c";
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
