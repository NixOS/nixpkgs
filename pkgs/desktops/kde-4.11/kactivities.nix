{ kde, kdelibs, nepomuk_core }:

kde {
  propagatedBuildInputs = [ kdelibs nepomuk_core ];

  meta = {
    description = "KDE activities library and daemon";
  };
}
