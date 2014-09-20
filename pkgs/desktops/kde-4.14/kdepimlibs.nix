{ kde, pkgconfig, boost, cyrus_sasl, gpgme, libical, openldap, prison
, kdelibs, akonadi, libxslt, nepomuk_core
, shared_desktop_ontologies, qjson }:

kde {
  nativeBuildInputs = [ pkgconfig ];

  buildInputs =
    [ boost gpgme libical libxslt qjson prison
      openldap cyrus_sasl akonadi shared_desktop_ontologies
    ];

  propagatedBuildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
