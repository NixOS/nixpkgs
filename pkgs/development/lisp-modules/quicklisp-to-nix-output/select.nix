/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "select";
  version = "20210411-git";

  parasites = [ "select/tests" ];

  description = "DSL for array slices.";

  deps = [ args."alexandria" args."anaphora" args."fiveam" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/select/2021-04-11/select-20210411-git.tgz";
    sha256 = "02xag0vpnqzfzw2mvrw6nwfhhy0iwq3zcvdh60cvx39labfvfdgb";
  };

  packageName = "select";

  asdFilesToKeep = ["select.asd"];
  overrides = x: x;
}
/* (SYSTEM select DESCRIPTION DSL for array slices. SHA256
    02xag0vpnqzfzw2mvrw6nwfhhy0iwq3zcvdh60cvx39labfvfdgb URL
    http://beta.quicklisp.org/archive/select/2021-04-11/select-20210411-git.tgz
    MD5 3e9c06e580f9e3a8911317ae8b95d0da NAME select FILENAME select DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME fiveam FILENAME fiveam) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora fiveam let-plus) VERSION 20210411-git
    SIBLINGS NIL PARASITES (select/tests)) */
