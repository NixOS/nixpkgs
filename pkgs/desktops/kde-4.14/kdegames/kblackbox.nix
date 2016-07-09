{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A game of hide and seek played on an grid of boxes, where the player shoots rays into the grid to deduce the positions of hidden objects";
  };
}
