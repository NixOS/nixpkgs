{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Batch search and replace tool";
    homepage = http://www.kdewebdev.org;
  };
}
