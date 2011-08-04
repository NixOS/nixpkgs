{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, libtool }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi libtool ];

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
