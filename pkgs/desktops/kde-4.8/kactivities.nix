{ kde, kdelibs, shared_desktop_ontologies }:

kde {
  propagatedBuildInputs = [ kdelibs shared_desktop_ontologies ];

  meta = {
    description = "KDE activities library and daemon";
  };
}
