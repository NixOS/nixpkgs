{ kde, cmake, kdelibs, automoc4, kdebase }:

kde.package {
  # Needs kdebase for libkonq
  buildInputs = [ cmake kdelibs automoc4 kdebase ];


  meta = {
    description = "Git and Svn plugins for dolphin";
    kde = {
      name = "dolphin-plugins";
      module = "kdesdk";
      version = "4.5.2";
    };
  };
}
