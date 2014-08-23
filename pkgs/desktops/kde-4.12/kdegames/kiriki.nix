{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "an addictive and fun dice game, designed to be played by as many as six players";
  };
}
