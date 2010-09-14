{ kde, cmake, kdelibs, qt4, perl, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE Wallet (password storage) management tool";
    kde = {
      name = "kwallet";
      module = "kdeutils";
      version = "1.6";
      release = "4.5.1";
    };
  };
}
