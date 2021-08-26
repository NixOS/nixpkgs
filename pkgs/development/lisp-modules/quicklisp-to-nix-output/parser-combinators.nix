/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parser-combinators";
  version = "cl-20131111-git";

  description = "An implementation of parser combinators for Common Lisp";

  deps = [ args."alexandria" args."iterate" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-parser-combinators/2013-11-11/cl-parser-combinators-20131111-git.tgz";
    sha256 = "0wg1a7favbwqcxyqcy2zxi4l11qsp4ar9fvddmx960grf2d72lds";
  };

  packageName = "parser-combinators";

  asdFilesToKeep = ["parser-combinators.asd"];
  overrides = x: x;
}
/* (SYSTEM parser-combinators DESCRIPTION
    An implementation of parser combinators for Common Lisp SHA256
    0wg1a7favbwqcxyqcy2zxi4l11qsp4ar9fvddmx960grf2d72lds URL
    http://beta.quicklisp.org/archive/cl-parser-combinators/2013-11-11/cl-parser-combinators-20131111-git.tgz
    MD5 25ad9b1459901738a6394422a41b8fec NAME parser-combinators FILENAME
    parser-combinators DEPS
    ((NAME alexandria FILENAME alexandria) (NAME iterate FILENAME iterate))
    DEPENDENCIES (alexandria iterate) VERSION cl-20131111-git SIBLINGS
    (parser-combinators-cl-ppcre parser-combinators-debug
     parser-combinators-tests)
    PARASITES NIL) */
