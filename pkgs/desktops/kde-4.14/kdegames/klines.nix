{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a simple but highly addictive one player game. The player has to move the colored balls around the game board, gathering them into the lines of the same color by five";
  };
}
