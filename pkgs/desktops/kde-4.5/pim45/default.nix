{ kde, automoc4, cmake, kdelibs, akonadi, kdepimlibs, boost, zlib, strigi,
  shared_desktop_ontologies, soprano, grantlee, libassuan, perl, libxslt }:

kde.package {
  buildInputs = [ automoc4 cmake kdelibs akonadi kdepimlibs boost zlib strigi
    shared_desktop_ontologies soprano grantlee libassuan perl libxslt ];

  patches = [ ./boost-1.44.diff ];

  meta = {
    kde = rec {
      name = "kdepim";
      version = "4.4.93";
      subdir = "kdepim/${version}/src/src";
      stable = false;
    };
  };
}
