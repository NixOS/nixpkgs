{ kde, pkgconfig, boost, cyrus_sasl, gpgme, libical, openldap, prison
, kdelibs, akonadi, libxslt
, shared_mime_info, shared_desktop_ontologies, qjson
, automoc4, cmake_2_8, perl
}:

kde {
  outputs = [ "out" "dev" ];

  outputInclude = "out";

  setOutputFlags = false;

  nativeBuildInputs = [ automoc4 cmake_2_8 perl pkgconfig ];

  cmakeFlags = [
    "-DCMAKE_MINIMUM_REQUIRED_VERSION=3.3"
  ];

  buildInputs =
    [ boost gpgme libical libxslt qjson prison
      openldap cyrus_sasl akonadi shared_desktop_ontologies
      shared_mime_info
    ];

  propagatedBuildInputs = [ kdelibs ];

  # Prevent a dependency on boost.dev. FIXME: move this cmake file to .dev.
  postInstall = "rm $out/lib/gpgmepp/GpgmeppConfig.cmake";

  meta = {
    description = "KDE PIM libraries";
    license = "LGPL";
  };
}
