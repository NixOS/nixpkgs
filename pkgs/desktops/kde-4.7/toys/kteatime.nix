{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon ];

  meta = {
    description = "KDE utility for making a fine cup of tea";
    kde = {
      name = "kteatime";
      module = "kdetoys";
      version = "1.2.1";
    };
  };
}
