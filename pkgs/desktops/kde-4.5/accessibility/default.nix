{kde, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4 }:

kde.package {
  # TODO: speech dispatcher and/or freetts
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 ];

  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    kde = {
      name = "kdeaccessibility";
      version = "4.5.0";
    };
  };
}
