{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A Gomoku (from Japanese 五目並べ - lit. \"five points\") like game for two players, where the opponents alternate in placing their respective pictogram on the game board";
  };

}
