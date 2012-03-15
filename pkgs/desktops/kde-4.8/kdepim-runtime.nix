{ kde, fetchurl, cmake, kdelibs, libxml2, libxslt, boost, kdepimlibs, akonadi
, shared_desktop_ontologies }:

kde {
  buildInputs = [ kdepimlibs akonadi boost shared_desktop_ontologies libxml2
    libxslt ];

  meta = {
    description = "KDE PIM runtime";
    license = "GPL";
  };
}
