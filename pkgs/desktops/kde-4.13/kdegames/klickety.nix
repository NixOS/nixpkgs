{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a puzzle game where the player removes groups of colored marbles to clear the board";
  };
}
