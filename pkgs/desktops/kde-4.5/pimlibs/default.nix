{ kde, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, akonadi, soprano}:

kde.package {

  buildInputs = [ cmake automoc4 perl shared_mime_info ];
  propagatedBuildInputs = [ qt4 boost cyrus_sasl gpgme libical openldap kdelibs
    akonadi soprano ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    kde = {
      name = "kdepimlibs";
      version = "4.5.1";
    };
  };
}
