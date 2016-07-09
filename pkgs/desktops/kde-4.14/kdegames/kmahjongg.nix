{ kde, kdelibs, libkdegames, libkmahjongg }:
kde {
  buildInputs = [ kdelibs libkdegames libkmahjongg ];
  meta = {
    description = "The tiles are scrambled and staked on top of each other to resemble a certain shape. The player is then expected to remove all the tiles off the game board by locating each tile's matching pair";
  };
}
