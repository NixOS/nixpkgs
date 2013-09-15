{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "the KDE version of Gnu-Lactic Konquest";
  };
}
