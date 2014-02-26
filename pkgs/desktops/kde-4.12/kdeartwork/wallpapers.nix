{ kde, kdelibs }:

kde rec {
  name = "kdeartwork-wallpapers";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE wallpapers";
  };
}
