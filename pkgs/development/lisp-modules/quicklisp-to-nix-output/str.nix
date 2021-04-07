/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "str";
  version = "cl-20210124-git";

  description = "Modern, consistent and terse Common Lisp string manipulation library.";

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-str/2021-01-24/cl-str-20210124-git.tgz";
    sha256 = "07y24mx8gmhwz6px63llgsz15aqicqa4m8gd5zwxy708xggv73jc";
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 07y24mx8gmhwz6px63llgsz15aqicqa4m8gd5zwxy708xggv73jc URL
    http://beta.quicklisp.org/archive/cl-str/2021-01-24/cl-str-20210124-git.tgz
    MD5 afd5d3e1078bef872b0507215855397e NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20210124-git SIBLINGS (str.test) PARASITES NIL) */
