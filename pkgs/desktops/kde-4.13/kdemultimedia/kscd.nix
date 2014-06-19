{ kde, kdelibs, libmusicbrainz }:
kde {
  buildInputs = [ kdelibs libmusicbrainz ];
  meta = {
    description = "KDE CD player";
  };
}
