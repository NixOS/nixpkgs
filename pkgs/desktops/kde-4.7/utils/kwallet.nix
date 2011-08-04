{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE Wallet (password storage) management tool";
    kde = {
      name = "kwallet";
      module = "kdeutils";
      version = "1.6";
      versionFile = "main.cpp";
    };
  };
}
