{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A graphical editor of scripted dialogs";
  };
}
