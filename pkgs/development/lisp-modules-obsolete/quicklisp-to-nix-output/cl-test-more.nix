/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-test-more";
  version = "prove-20200218-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-colors2" args."cl-ppcre" args."let-plus" args."prove" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/prove/2020-02-18/prove-20200218-git.tgz";
    sha256 = "1sv3zyam9sdmyis5lyv0khvw82q7bcpsycpj9b3bsv9isb4j30zn";
  };

  packageName = "cl-test-more";

  asdFilesToKeep = ["cl-test-more.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-test-more DESCRIPTION System lacks description SHA256
    1sv3zyam9sdmyis5lyv0khvw82q7bcpsycpj9b3bsv9isb4j30zn URL
    http://beta.quicklisp.org/archive/prove/2020-02-18/prove-20200218-git.tgz
    MD5 85780b65e84c17a78d658364b8c4d11b NAME cl-test-more FILENAME
    cl-test-more DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-colors2 FILENAME cl-colors2)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME let-plus FILENAME let-plus)
     (NAME prove FILENAME prove))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-colors2 cl-ppcre let-plus
     prove)
    VERSION prove-20200218-git SIBLINGS (prove-asdf prove-test prove) PARASITES
    NIL) */
