{ kde, boost, cyrus_sasl, gpgme, libical, openldap, shared_mime_info
, kdelibs, akonadi, shared_desktop_ontologies, libxml2, libxslt, prison }:

kde {
  buildInputs =
    [ boost gpgme shared_desktop_ontologies libical libxml2 libxslt
      openldap cyrus_sasl akonadi prison
    ];

  propagatedBuildInputs = [ kdelibs ];

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
