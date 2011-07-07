{ kde, cmake, kdelibs, automoc4, libtool }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libtool ];

  meta = {
    description = "Measures start up time of a KDE application";
    kde = {
      name = "kstartperf";
      module = "kdesdk";
      version = "1.0";
      versionFile = "kstartperf.cpp";
    };
  };
}
