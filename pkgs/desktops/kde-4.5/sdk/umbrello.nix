{ kde, cmake, kdelibs, automoc4, libxml2, libxslt, boost }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt boost ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "Umbrello UML modeller";
    kde = {
      name = "umbrello";
      module = "kdesdk";
      version = "2.5.1";
      release = "4.5.1";
    };
  };
}
