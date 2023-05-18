/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "calispel";
  version = "20170830-git";

  parasites = [ "calispel-test" ];

  description = "Thread-safe message-passing channels, in the style of
the occam programming language.";

  deps = [ args."alexandria" args."bordeaux-threads" args."eager-future2" args."jpl-queues" args."jpl-util" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/calispel/2017-08-30/calispel-20170830-git.tgz";
    sha256 = "0qwmzmyh63jlw5bdv4wf458n1dz9k77gd5b4ix1kd6xrzx247k7i";
  };

  packageName = "calispel";

  asdFilesToKeep = ["calispel.asd"];
  overrides = x: x;
}
/* (SYSTEM calispel DESCRIPTION
    Thread-safe message-passing channels, in the style of
the occam programming language.
    SHA256 0qwmzmyh63jlw5bdv4wf458n1dz9k77gd5b4ix1kd6xrzx247k7i URL
    http://beta.quicklisp.org/archive/calispel/2017-08-30/calispel-20170830-git.tgz
    MD5 1fba6e4b2055f5d1f0a78387e29552b1 NAME calispel FILENAME calispel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME eager-future2 FILENAME eager-future2)
     (NAME jpl-queues FILENAME jpl-queues) (NAME jpl-util FILENAME jpl-util))
    DEPENDENCIES
    (alexandria bordeaux-threads eager-future2 jpl-queues jpl-util) VERSION
    20170830-git SIBLINGS NIL PARASITES (calispel-test)) */
