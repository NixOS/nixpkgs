{ kde, kdelibs }:

kde {

  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE file metadata something";
    license = "GPLv2";
  };
}
