{ kde, kdelibs, libXtst }:

kde {
  buildInputs = [ kdelibs libXtst ];

  meta = {
    description = "A program that clicks the mouse for you";
  };
}
