{ kde, libxslt, boost, kdepimlibs, akonadi, shared_desktop_ontologies }:

kde {

# TODO: libkgapi(2), LibKFbAPI,libkolab, libkolabxml

  buildInputs = [
    kdepimlibs akonadi boost shared_desktop_ontologies
    libxslt
  ];

  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
