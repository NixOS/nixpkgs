{ kde, kdelibs, antlr }:

kde {
  buildInputs = [ kdelibs antlr ];

  meta = {
    description = "Po<->xml tools";
  };
}
