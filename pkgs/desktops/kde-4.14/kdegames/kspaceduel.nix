{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "Each of two possible players control a satellite spaceship orbiting the sun. As the game progresses players have to eliminate the opponent's spacecraft with bullets or mines";
  };
}
