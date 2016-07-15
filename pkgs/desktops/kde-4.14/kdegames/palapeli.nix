{ kde, kdelibs, libkdegames, shared_mime_info }:
kde {

# TODO: package qvoronoi

  nativeBuildInputs = [ shared_mime_info ];

  buildInputs = [ kdelibs libkdegames ];

  meta = {
    description = "A single-player jigsaw puzzle game";
  };
}
