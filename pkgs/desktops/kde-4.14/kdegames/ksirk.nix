{ kde, kdelibs, libkdegames, qca2 }:
kde {
  buildInputs = [ kdelibs libkdegames qca2 ];
  meta = {
    description = "A computerized version of the well known strategic board game Risk";
  };
}
