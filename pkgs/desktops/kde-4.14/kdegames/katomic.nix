{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "A fun and educational puzzle game built around molecular geometry";
  };
}
