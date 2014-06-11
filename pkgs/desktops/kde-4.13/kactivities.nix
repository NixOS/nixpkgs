{ kde, kdelibs, baloo }:

kde {
  propagatedBuildInputs = [ kdelibs baloo ];

  meta = {
    description = "KDE activities library and daemon";
  };
}
