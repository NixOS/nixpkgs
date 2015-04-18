{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Qt Quick 1 plugin for beautiful and interactive charts";
  };
}
