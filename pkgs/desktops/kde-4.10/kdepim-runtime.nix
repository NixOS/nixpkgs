{ kde, fetchurl, cmake, kdelibs, libxslt, boost, kdepimlibs, akonadi
, shared_desktop_ontologies, nepomuk_core }:

kde {
  buildInputs = [
    kdepimlibs akonadi boost shared_desktop_ontologies
    libxslt nepomuk_core
  ];
#todo: libkgapi, libkolab, libkolabxml
  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
