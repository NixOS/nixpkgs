{ kde, libxslt, boost, kdepimlibs, akonadi, shared_desktop_ontologies
, shared_mime_info }:

kde {

# TODO: libkgapi(2), LibKFbAPI,libkolab, libkolabxml

  buildInputs = [
    kdepimlibs akonadi boost shared_desktop_ontologies
    libxslt
  ];

  nativeBuildInputs = [ shared_mime_info ];

  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
