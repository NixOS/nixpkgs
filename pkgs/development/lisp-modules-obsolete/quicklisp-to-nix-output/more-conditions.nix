/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "more-conditions";
  version = "20180831-git";

  parasites = [ "more-conditions/test" ];

  description = "This system provides some generic condition classes in
                conjunction with support functions and macros.";

  deps = [ args."alexandria" args."closer-mop" args."fiveam" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/more-conditions/2018-08-31/more-conditions-20180831-git.tgz";
    sha256 = "0wa989kv3sl977g9szxkx52fdnww6aj2a9i77363f90iq02vj97x";
  };

  packageName = "more-conditions";

  asdFilesToKeep = ["more-conditions.asd"];
  overrides = x: x;
}
/* (SYSTEM more-conditions DESCRIPTION
    This system provides some generic condition classes in
                conjunction with support functions and macros.
    SHA256 0wa989kv3sl977g9szxkx52fdnww6aj2a9i77363f90iq02vj97x URL
    http://beta.quicklisp.org/archive/more-conditions/2018-08-31/more-conditions-20180831-git.tgz
    MD5 c4797bd3c6c50fba02a6e8164ddafe28 NAME more-conditions FILENAME
    more-conditions DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria closer-mop fiveam let-plus) VERSION 20180831-git
    SIBLINGS NIL PARASITES (more-conditions/test)) */
