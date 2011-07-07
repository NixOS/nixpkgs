{ kde, cmake, kdelibs, automoc4 }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 ];

  meta = {
    description = "KDE utility for making a fine cup of tea";
    kde = {
      name = "kteatime";
      module = "kdetoys";
      version = "1.2.1";
    };
  };
}
