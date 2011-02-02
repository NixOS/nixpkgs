{ cmake, kde, automoc4, kdelibs }:

kde.package rec {
  name = "kde-sounds-${kde.release}";

  buildInputs = [ cmake automoc4 kdelibs ];
  meta = {
    description = "New login/logout sounds";
    kde = {
      name = "sounds";
      module = "kdeartwork";
    };
  };
}
