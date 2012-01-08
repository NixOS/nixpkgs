{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A program to view the differences between files and optionally generate a diff";
  };
}
