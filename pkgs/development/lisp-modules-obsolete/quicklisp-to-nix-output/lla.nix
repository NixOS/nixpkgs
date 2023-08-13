/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lla";
  version = "20180328-git";

  parasites = [ "lla-tests" ];

  description = "Lisp Linear Algebra";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."babel" args."cffi" args."cl-num-utils" args."cl-slice" args."clunit" args."let-plus" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lla/2018-03-28/lla-20180328-git.tgz";
    sha256 = "0azljp93ap9lh2gfh1vvl99r18s6a03p880c3wvwpf9valb784hj";
  };

  packageName = "lla";

  asdFilesToKeep = ["lla.asd"];
  overrides = x: x;
}
/* (SYSTEM lla DESCRIPTION Lisp Linear Algebra SHA256
    0azljp93ap9lh2gfh1vvl99r18s6a03p880c3wvwpf9valb784hj URL
    http://beta.quicklisp.org/archive/lla/2018-03-28/lla-20180328-git.tgz MD5
    61d583603d5cacf9d81486a0cfcfaf6a NAME lla FILENAME lla DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME babel FILENAME babel) (NAME cffi FILENAME cffi)
     (NAME cl-num-utils FILENAME cl-num-utils)
     (NAME cl-slice FILENAME cl-slice) (NAME clunit FILENAME clunit)
     (NAME let-plus FILENAME let-plus)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria anaphora array-operations babel cffi cl-num-utils cl-slice
     clunit let-plus trivial-features)
    VERSION 20180328-git SIBLINGS NIL PARASITES (lla-tests)) */
