{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a classic Minesweeper game";
  };
}
