/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "str";
  version = "cl-20210531-git";

  description = "Modern, consistent and terse Common Lisp string manipulation library.";

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-str/2021-05-31/cl-str-20210531-git.tgz";
    sha256 = "16z1axfik0s2m74ly4bxlrv4mbd2r923y7nrrrc487fsjs3v23bb";
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 16z1axfik0s2m74ly4bxlrv4mbd2r923y7nrrrc487fsjs3v23bb URL
    http://beta.quicklisp.org/archive/cl-str/2021-05-31/cl-str-20210531-git.tgz
    MD5 05144979ce1bf382fdb0b91db932fe6a NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20210531-git SIBLINGS (str.test) PARASITES NIL) */
