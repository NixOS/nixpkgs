{ kde, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, akonadi, libxslt, prison, nepomuk_core
, shared_desktop_ontologies, qjson }:

kde {
  buildInputs =
    [ boost gpgme libical libxslt qjson
      openldap cyrus_sasl akonadi shared_desktop_ontologies
    ];

  propagatedBuildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
