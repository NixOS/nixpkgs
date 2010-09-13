{ kde, cmake, kdelibs, automoc4, shared_mime_info }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 shared_mime_info ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "Kate - Advanced Text Editor";
    kde = {
      name = "kate";
      module = "kdesdk";
      version = "3.5.1";
      release = "4.5.1";
    };
  };
}
