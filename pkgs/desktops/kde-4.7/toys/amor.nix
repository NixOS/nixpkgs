{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "KDE creature for your desktop";
    kde = {
      name = "amor";
      module = "kdetoys";
      version = "2.4.0";
      versionFile = "src/version.h";
    };
  };
}
