{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];
  meta = {
    description = "a multimedia player with the focus on simplicity";
  };
}
