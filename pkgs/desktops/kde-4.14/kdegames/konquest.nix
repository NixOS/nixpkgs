{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "The KDE version of Gnu-Lactic Konquest";
  };
}
