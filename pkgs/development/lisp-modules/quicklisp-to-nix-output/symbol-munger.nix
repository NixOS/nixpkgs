/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "symbol-munger";
  version = "20220220-git";

  parasites = [ "symbol-munger/test" ];

  description = "Functions to convert between the spacing and
  capitalization conventions of various environments";

  deps = [ args."alexandria" args."iterate" args."lisp-unit2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/symbol-munger/2022-02-20/symbol-munger-20220220-git.tgz";
    sha256 = "1zz7lzbnbr4l42dk5z9w0rhnlh2c9b6xszgkcgyf0h3s4rs6lwlf";
  };

  packageName = "symbol-munger";

  asdFilesToKeep = ["symbol-munger.asd"];
  overrides = x: x;
}
/* (SYSTEM symbol-munger DESCRIPTION
    Functions to convert between the spacing and
  capitalization conventions of various environments
    SHA256 1zz7lzbnbr4l42dk5z9w0rhnlh2c9b6xszgkcgyf0h3s4rs6lwlf URL
    http://beta.quicklisp.org/archive/symbol-munger/2022-02-20/symbol-munger-20220220-git.tgz
    MD5 1490f027785e2ca1ec7cd138cd2864ce NAME symbol-munger FILENAME
    symbol-munger DEPS
    ((NAME alexandria FILENAME alexandria) (NAME iterate FILENAME iterate)
     (NAME lisp-unit2 FILENAME lisp-unit2))
    DEPENDENCIES (alexandria iterate lisp-unit2) VERSION 20220220-git SIBLINGS
    NIL PARASITES (symbol-munger/test)) */
