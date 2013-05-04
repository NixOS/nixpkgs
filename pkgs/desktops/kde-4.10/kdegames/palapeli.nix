{ kde, kdelibs, libkdegames }:
kde {
#todo:package qvoronoi
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a single-player jigsaw puzzle game";
  };
}
