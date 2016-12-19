{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A simple one player strategy game played against the computer. If a player's piece is captured by an opposing player, that piece is turned over to reveal the color of that player";
  };
}
