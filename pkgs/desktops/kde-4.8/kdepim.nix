{ kde, boost, gpgme, libassuan, libxml2, libxslt, kdepimlibs, kdepim_runtime
, akonadi, shared_desktop_ontologies, cyrus_sasl, grantlee }:

kde {

  buildInputs =
    [ kdepimlibs boost akonadi shared_desktop_ontologies libxml2
      libxslt cyrus_sasl gpgme libassuan grantlee
    ];

  passthru.propagatedUserEnvPackages = [ akonadi kdepimlibs kdepim_runtime ];

  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer.
    '';
    license = "GPL";
    homepage = http://pim.kde.org;
  };
}
