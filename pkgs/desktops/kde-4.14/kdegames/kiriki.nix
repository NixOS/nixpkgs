{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "An addictive and fun dice game, designed to be played by as many as six players";
  };
}
