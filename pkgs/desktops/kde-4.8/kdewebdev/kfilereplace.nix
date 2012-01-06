{ kde, kdelibs, libxml2, libxslt }:

kde {
  buildInputs = [ kdelibs libxml2 libxslt ];

  meta = {
    description = "Batch search and replace tool";
    homepage = http://www.kdewebdev.org;
  };
}
