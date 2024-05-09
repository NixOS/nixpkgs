/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-cookie";
  version = "20191007-git";

  description = "HTTP cookie manager";

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."cl-utilities" args."local-time" args."proc-parse" args."quri" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-cookie/2019-10-07/cl-cookie-20191007-git.tgz";
    sha256 = "1xcb69n3qfp37nwj0mj2whf3yj5xfsgh9sdw6c64gxqkiiq9nfhh";
  };

  packageName = "cl-cookie";

  asdFilesToKeep = ["cl-cookie.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cookie DESCRIPTION HTTP cookie manager SHA256
    1xcb69n3qfp37nwj0mj2whf3yj5xfsgh9sdw6c64gxqkiiq9nfhh URL
    http://beta.quicklisp.org/archive/cl-cookie/2019-10-07/cl-cookie-20191007-git.tgz
    MD5 37595a6705fdd77415b859aea90d30bc NAME cl-cookie FILENAME cl-cookie DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME local-time FILENAME local-time)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-ppcre cl-utilities local-time proc-parse quri
     split-sequence trivial-features)
    VERSION 20191007-git SIBLINGS (cl-cookie-test) PARASITES NIL) */
