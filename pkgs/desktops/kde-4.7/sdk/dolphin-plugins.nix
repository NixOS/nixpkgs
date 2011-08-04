{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, kde_baseapps, kdepimlibs }:

kde.package {
  # Needs kdebase for libkonq
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi kde_baseapps ];

  cmakeFlags = "-DBUILD_dolphin-plugins/svn=TRUE -DBUILD_dolphin-plugins/git=TRUE";
  
  meta = {
    description = "Git and Svn plugins for dolphin";
    kde = {
      name = "dolphin-plugins";
      module = "kdesdk";
    };
  };
}
