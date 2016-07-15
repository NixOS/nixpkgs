{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A fun and engaging card game for two players, where the second player is either live opponent, or a built in artificial intelligence";
  };
}
