{ kde, kdelibs, libkdegames }:
kde {

# TODO: package qvoronoi

  buildInputs = [ kdelibs libkdegames ];

  meta = {
    description = "a single-player jigsaw puzzle game";
  };
}
