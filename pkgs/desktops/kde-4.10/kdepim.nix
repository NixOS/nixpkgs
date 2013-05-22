{ kde, boost, gpgme, libassuan, libxslt, kdepimlibs, kdepim_runtime
, akonadi, shared_desktop_ontologies, cyrus_sasl, grantlee, prison
, nepomuk_widgets, dblatex }:

kde {
#todo: update grantlee to 0.3
  buildInputs =
    [ kdepimlibs boost akonadi shared_desktop_ontologies nepomuk_widgets
      libxslt cyrus_sasl gpgme libassuan grantlee prison dblatex
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
