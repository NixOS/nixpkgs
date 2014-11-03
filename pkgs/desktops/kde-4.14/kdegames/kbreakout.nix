{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a Breakout-like game. Its object is to destroy as many bricks as possible without losing the ball";
  };
}
