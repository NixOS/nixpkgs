{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A KDE CVS frontend";
  };
}
