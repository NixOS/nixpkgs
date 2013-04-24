{ kde, kdelibs, subversionClient, apr, aprutil }:

kde {
#todo: doesn't build
  buildInputs = [ kdelibs subversionClient apr aprutil ];

  patches = [ ./find-svn.patch ];

  meta = {
    description = "Subversion kioslave";
  };
}
