{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE Timer";
  };
}
