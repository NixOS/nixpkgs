{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A single player puzzle game. The object of the game is to build lines of three similar diamonds";
  };
}
