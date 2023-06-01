/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lparallel";
  version = "20160825-git";

  description = "Parallelism for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz";
    sha256 = "0wwwwszbj6m0b2rsp8mpn4m6y7xk448bw8fb7gy0ggmsdfgchfr1";
  };

  packageName = "lparallel";

  asdFilesToKeep = ["lparallel.asd"];
  overrides = x: x;
}
/* (SYSTEM lparallel DESCRIPTION Parallelism for Common Lisp SHA256
    0wwwwszbj6m0b2rsp8mpn4m6y7xk448bw8fb7gy0ggmsdfgchfr1 URL
    http://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz
    MD5 6393e8d0c0cc9ed1c88b6e7cca8de5df NAME lparallel FILENAME lparallel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads))
    DEPENDENCIES (alexandria bordeaux-threads) VERSION 20160825-git SIBLINGS
    (lparallel-bench lparallel-test) PARASITES NIL) */
