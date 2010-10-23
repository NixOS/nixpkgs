{ kde, cmake, kdelibs, automoc4, shared_mime_info }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 shared_mime_info ];


  meta = {
    description = "Kate - Advanced Text Editor";
    kde = {
      name = "kate";
      module = "kdesdk";
      version = "3.5.2"; # (release.major-1).(release.minor).(release.patch)
      release = "4.5.2";
    };
  };
}
