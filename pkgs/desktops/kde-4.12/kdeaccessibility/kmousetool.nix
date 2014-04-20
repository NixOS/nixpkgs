{ kde, kdelibs, libXtst, libXt }:

kde {
  buildInputs = [ kdelibs libXtst libXt ];

  meta = {
    description = "A program that clicks the mouse for you";
  };
}
