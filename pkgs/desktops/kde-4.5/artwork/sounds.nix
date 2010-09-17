{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-sounds-${meta.kde.version}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "New login/logout sounds";
    kde = {
      name = "sounds";
      module = "kdeartwork";
      version = "4.5.1";
    };
  };
}
