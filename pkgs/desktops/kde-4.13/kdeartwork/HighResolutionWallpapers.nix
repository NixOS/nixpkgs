{ kde, kdelibs }:

kde rec {
  name = "kde-wallpapers-high-resolution";

  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE wallpapers in high resolution";
  };
}
