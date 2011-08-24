{ kde, kdelibs, subversion, apr, aprutil }:

kde {
  buildInputs = [ kdelibs subversion apr aprutil ];

  patches = [ ./find-svn.patch ];

  meta = {
    description = "Subversion kioslave";
  };
}
