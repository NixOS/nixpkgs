{ kde, cmake, kdelibs, automoc4, libxml2, libxslt }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt ];

  meta = {
    description = "Batch search and replace tool";
    homepage = http://www.kdewebdev.org;
    kde = {
      name = "kfilereplace";
      module = "kdewebdev";
      version = "0.1";
      release = "4.5.1";
    };
  };
}
