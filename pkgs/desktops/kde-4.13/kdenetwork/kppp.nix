{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "PPP(Dial-Up) client tool";
  };
}
