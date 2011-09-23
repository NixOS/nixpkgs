{ kde, kdelibs, subversionClient, apr, aprutil }:

kde {
  buildInputs = [ kdelibs subversionClient apr aprutil ];

  patches = [ ./find-svn.patch ];

  meta = {
    description = "Subversion kioslave";
  };
}
