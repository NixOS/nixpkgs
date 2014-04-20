{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];
  meta = {
    description = "KDE library for playing & ripping CDs";
  };
}
