{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];
  meta = {
    description = "A multimedia player with the focus on simplicity";
  };
}
