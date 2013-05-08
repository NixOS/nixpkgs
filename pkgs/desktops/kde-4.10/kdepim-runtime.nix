{ kde, fetchurl, cmake, kdelibs, libxslt, boost, kdepimlibs, akonadi
, shared_desktop_ontologies }:

kde {
  buildInputs = [
    kdepimlibs akonadi boost shared_desktop_ontologies
    libxslt
  ];
#todo: libkgapi, libkolab, libkolabxml
  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
