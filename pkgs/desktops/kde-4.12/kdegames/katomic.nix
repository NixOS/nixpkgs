{ kde, kdelibs, libkdegames }:
kde {
  buildInputs = [ kdelibs libkdegames ];
  meta = {
    description = "a fun and educational puzzle game built around molecular geometry";
  };
}
