{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Helps clean unwanted traces the user leaves on the system";
  };
}
