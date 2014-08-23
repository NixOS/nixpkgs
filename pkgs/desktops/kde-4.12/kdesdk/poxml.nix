{ kde, kdelibs, antlr, gettext }:

kde {
  buildInputs = [ kdelibs antlr gettext ];

  meta = {
    description = "Po<->xml tools";
  };
}
