{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];
  meta = {
    description = "A video thumbnail generator for KDE";
  };
}
