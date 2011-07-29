{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, libxml2, libxslt, boost }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi libxml2 libxslt boost ];

  meta = {
    description = "Umbrello UML modeller";
    kde = {
      name = "umbrello";
      module = "kdesdk";
      version = "2.5.2"; # release - 200
    };
  };
}
