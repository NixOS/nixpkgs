{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a fun and engaging card game for two players, where the second player is either live opponent, or a built in artificial intelligence";
  };
}
