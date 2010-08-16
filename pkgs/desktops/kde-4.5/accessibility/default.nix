{kdePackage, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4 }:

kdePackage {
  pn = "kdeaccessibility";
  v = "4.5.0";

  # TODO: speech dispatcher and/or freetts
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 ];

  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
  };
}
