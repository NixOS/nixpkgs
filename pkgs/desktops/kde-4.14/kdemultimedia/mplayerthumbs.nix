{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];
  meta = {
    description = "a video thumbnail generator for KDE";
  };
}
