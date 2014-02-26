{ kde, kdelibs, libkdegames, libkmahjongg }:
kde {
  buildInputs = [ kdelibs libkdegames libkmahjongg ];
  meta = {
    description = "a solitaire-like game played using the standard set of Mahjong tiles";
  };
}
