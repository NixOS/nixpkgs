{ kde, kdelibs }:

kde rec {
  name = "kde-wallpapers";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE wallpapers";
  };
}
