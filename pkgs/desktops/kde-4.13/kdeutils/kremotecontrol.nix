{ kde, kdelibs, libXtst }:

kde {
  buildInputs = [ kdelibs libXtst ];

  meta = {
    description = "KDE remote control";
  };
}
