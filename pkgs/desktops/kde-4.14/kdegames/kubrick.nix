{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A game based on the Rubik's Cube™ puzzle";
  };
}
