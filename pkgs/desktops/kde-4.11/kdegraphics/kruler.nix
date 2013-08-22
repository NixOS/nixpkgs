{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE screen ruler";
    license = "GPLv2";
  };
}
