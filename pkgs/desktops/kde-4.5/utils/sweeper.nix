{ kde, cmake, perl, kdelibs, qt4, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "Helps clean unwanted traces the user leaves on the system";
    kde = {
      name = "sweeper";
      module = "kdeutils";
      version = "1.5";
      release = "4.5.2";
      versionFile = "main.cpp";
    };
  };
}
