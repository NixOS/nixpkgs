{ kde, kdelibs, kdepimlibs }:

kde {
  buildInputs = [ kdelibs kdepimlibs ];

  meta = {
    description = "User management tool";
  };
}
