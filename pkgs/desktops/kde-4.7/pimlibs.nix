{ stdenv, kde, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, akonadi, soprano, phonon, shared_desktop_ontologies, libxslt }:

kde.package {

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon boost gpgme shared_mime_info
      shared_desktop_ontologies soprano libical libxslt openldap
      cyrus_sasl akonadi perl
    ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
    kde.name = "kdepimlibs";
  };
}
