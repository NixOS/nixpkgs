{ kdePackage, cmake, qt4, perl, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, automoc4, akonadi, soprano}:

kdePackage {
  pn = "kdepimlibs";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl boost cyrus_sasl gpgme libical openldap
    shared_mime_info kdelibs automoc4 akonadi soprano ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
