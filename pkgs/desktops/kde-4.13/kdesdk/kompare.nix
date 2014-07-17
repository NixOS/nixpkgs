{ kde, kdelibs, libkomparediff2 }:

kde {
  buildInputs = [ kdelibs libkomparediff2 ];

  meta = {
    description = "A program to view the differences between files and optionally generate a diff";
  };
}
