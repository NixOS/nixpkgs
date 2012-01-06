{ kde, kdelibs }:

kde {
  name = "aurorae-themes";

  buildInputs = [ kdelibs ];
}
