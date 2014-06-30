{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a game modeled after the well known pen and paper based game of Dots and Boxes";
  };
}
