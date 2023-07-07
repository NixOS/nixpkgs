/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "symbol-munger";
  version = "20150407-git";

  description = "Functions to convert between the spacing and
  capitalization conventions of various environments";

  deps = [ args."alexandria" args."iterate" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/symbol-munger/2015-04-07/symbol-munger-20150407-git.tgz";
    sha256 = "0dccli8557kvyy2rngh646rmavf96p7xqn5bry65d7c1f61lyqv6";
  };

  packageName = "symbol-munger";

  asdFilesToKeep = ["symbol-munger.asd"];
  overrides = x: x;
}
/* (SYSTEM symbol-munger DESCRIPTION
    Functions to convert between the spacing and
  capitalization conventions of various environments
    SHA256 0dccli8557kvyy2rngh646rmavf96p7xqn5bry65d7c1f61lyqv6 URL
    http://beta.quicklisp.org/archive/symbol-munger/2015-04-07/symbol-munger-20150407-git.tgz
    MD5 b1e35b63d7ad1451868d1c40e2fbfab7 NAME symbol-munger FILENAME
    symbol-munger DEPS
    ((NAME alexandria FILENAME alexandria) (NAME iterate FILENAME iterate))
    DEPENDENCIES (alexandria iterate) VERSION 20150407-git SIBLINGS NIL
    PARASITES NIL) */
