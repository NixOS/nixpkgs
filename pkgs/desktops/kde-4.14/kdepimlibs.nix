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

  # Prevent a dependency on boost.dev. FIXME: move this cmake file to .dev.
  postInstall = "rm $out/lib/gpgmepp/GpgmeppConfig.cmake";

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
