{ kde, cmake, kdelibs, automoc4, libxml2, libxslt, boost }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt boost ];


  meta = {
    description = "Umbrello UML modeller";
    kde = {
      name = "umbrello";
      module = "kdesdk";
      version = "2.5.2"; # release - 200
      release = "4.5.2";
    };
  };
}
