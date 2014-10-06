{ kde, kdelibs }:

kde {
  name = "kde-color-schemes";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE color schemes";
  };
}
