{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  enableParallelBuilding = false;

  meta = {
    description = "KDE free disk space utility";
  };
}
