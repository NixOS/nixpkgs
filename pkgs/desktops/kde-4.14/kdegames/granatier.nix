{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A clone of the classic Bomberman game, inspired by the work of the Clanbomber clone";
  };
}
