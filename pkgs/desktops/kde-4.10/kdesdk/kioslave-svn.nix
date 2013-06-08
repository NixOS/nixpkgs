{ kde, kdelibs, subversionClient, apr, aprutil }:

kde {

  buildInputs = [ kdelibs subversionClient apr aprutil ];

  meta = {
    description = "Subversion kioslave";
  };
}
