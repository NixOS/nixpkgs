{ kde, boost, gpgme, libassuan, libxslt, kdepimlibs, kdepim_runtime
, akonadi, shared_desktop_ontologies, cyrus_sasl, grantlee, prison
, baloo_widgets, kactivities, libXScrnSaver, qjson
, pkgconfig }:

kde {

# TODO: LinkGrammar

  buildInputs =
    [ kdepimlibs boost shared_desktop_ontologies akonadi baloo_widgets
      libxslt cyrus_sasl gpgme libassuan grantlee prison kactivities
      libXScrnSaver qjson
    ];

  nativeBuildInputs = [ pkgconfig ];

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
