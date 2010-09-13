{ kde, cmake, kdelibs, automoc4, kdebase }:

kde.package {
  # Needs kdebase for libkonq
  buildInputs = [ cmake kdelibs automoc4 kdebase ];

  patches = [ ./optional-docs.diff ];

  meta = {
    description = "Git and Svn plugins for dolphin";
    kde = {
      name = "dolphin-plugins";
      module = "kdesdk";
      version = "3.5.0";
      release = "4.5.1";
    };
  };
}
