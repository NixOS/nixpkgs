{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A library for KMahjongg game";
  };
}
