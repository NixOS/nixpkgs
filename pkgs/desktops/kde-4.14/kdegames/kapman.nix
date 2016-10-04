{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A clone of the well known game Pac-Man";
  };
}
