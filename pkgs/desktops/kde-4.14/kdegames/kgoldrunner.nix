{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "an action game where the hero runs through a maze, climbs stairs, dig holes and dodges enemies in order to collect all the gold nuggets and escape to the next level";
  };
}
