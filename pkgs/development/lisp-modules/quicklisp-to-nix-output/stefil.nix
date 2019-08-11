args @ { fetchurl, ... }:
rec {
  baseName = ''stefil'';
  version = ''20181210-git'';

  parasites = [ "stefil-test" ];

  description = ''Stefil - Simple Test Framework In Lisp'';

  deps = [ args."alexandria" args."iterate" args."metabang-bind" args."swank" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stefil/2018-12-10/stefil-20181210-git.tgz'';
    sha256 = ''10dr8yjrjc2pyx55knds5llh9k716khlvbkmpxh0vn8rdmxmz96g'';
  };

  packageName = "stefil";

  asdFilesToKeep = ["stefil.asd"];
  overrides = x: x;
}
/* (SYSTEM stefil DESCRIPTION Stefil - Simple Test Framework In Lisp SHA256
    10dr8yjrjc2pyx55knds5llh9k716khlvbkmpxh0vn8rdmxmz96g URL
    http://beta.quicklisp.org/archive/stefil/2018-12-10/stefil-20181210-git.tgz
    MD5 3418bf358366748593f65e4b6e1bb8cf NAME stefil FILENAME stefil DEPS
    ((NAME alexandria FILENAME alexandria) (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank))
    DEPENDENCIES (alexandria iterate metabang-bind swank) VERSION 20181210-git
    SIBLINGS NIL PARASITES (stefil-test)) */
