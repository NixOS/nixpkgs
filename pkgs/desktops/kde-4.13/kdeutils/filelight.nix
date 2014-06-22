{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Tool to visualise file and directory sizes";
  };
}
