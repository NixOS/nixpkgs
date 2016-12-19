{ kde, kdelibs }:
kde {
#todo: libmusicbrainz5
  buildInputs = [ kdelibs ];
  meta = {
    description = "A library used to retrieve audio CD meta data from the internet";
  };
}
