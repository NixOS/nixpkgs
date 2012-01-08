{ kde, kdelibs }:

kde {
  propagatedBuildInputs = [ kdelibs ];

  meta = {
    description = "KDE activities library and daemon";
  };
}
