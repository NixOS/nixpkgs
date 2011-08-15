{ kde, kdelibs }:

kde {
  name = "kde-desktop-themes";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE desktop themes";
  };
}
