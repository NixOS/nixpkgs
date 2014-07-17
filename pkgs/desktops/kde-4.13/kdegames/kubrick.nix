{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a game based on the Rubik's Cube™ puzzle";
  };
}
