/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-html-parse";
  version = "20200925-git";

  description = "HTML Parser";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-html-parse/2020-09-25/cl-html-parse-20200925-git.tgz";
    sha256 = "14pfd4gwjb8ywr79dqrcznw6h8a1il3g5b6cm5x9aiyr49zdv15f";
  };

  packageName = "cl-html-parse";

  asdFilesToKeep = ["cl-html-parse.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-html-parse DESCRIPTION HTML Parser SHA256
    14pfd4gwjb8ywr79dqrcznw6h8a1il3g5b6cm5x9aiyr49zdv15f URL
    http://beta.quicklisp.org/archive/cl-html-parse/2020-09-25/cl-html-parse-20200925-git.tgz
    MD5 3333eedf037a48900c663fceae3e4cfd NAME cl-html-parse FILENAME
    cl-html-parse DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS NIL
    PARASITES NIL) */
