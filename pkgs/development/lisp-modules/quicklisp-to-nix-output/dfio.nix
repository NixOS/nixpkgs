/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dfio";
  version = "20210411-git";

  description = "Common Lisp library for reading data from text files (eg CSV).";

  deps = [ args."alexandria" args."anaphora" args."array-operations" args."cl-csv" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."data-frame" args."flexi-streams" args."iterate" args."let-plus" args."named-readtables" args."num-utils" args."select" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/dfio/2021-04-11/dfio-20210411-git.tgz";
    sha256 = "0r1ljv22mfjlp0khgfbmh9ajp9qmw8lqj2wl6k9abr5cc32vnmi5";
  };

  packageName = "dfio";

  asdFilesToKeep = ["dfio.asd"];
  overrides = x: x;
}
/* (SYSTEM dfio DESCRIPTION
    Common Lisp library for reading data from text files (eg CSV). SHA256
    0r1ljv22mfjlp0khgfbmh9ajp9qmw8lqj2wl6k9abr5cc32vnmi5 URL
    http://beta.quicklisp.org/archive/dfio/2021-04-11/dfio-20210411-git.tgz MD5
    f8d9923e8c2fb095c7dbc1c9f6b68568 NAME dfio FILENAME dfio DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME array-operations FILENAME array-operations)
     (NAME cl-csv FILENAME cl-csv) (NAME cl-interpol FILENAME cl-interpol)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME data-frame FILENAME data-frame)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME let-plus FILENAME let-plus)
     (NAME named-readtables FILENAME named-readtables)
     (NAME num-utils FILENAME num-utils) (NAME select FILENAME select))
    DEPENDENCIES
    (alexandria anaphora array-operations cl-csv cl-interpol cl-ppcre
     cl-unicode data-frame flexi-streams iterate let-plus named-readtables
     num-utils select)
    VERSION 20210411-git SIBLINGS NIL PARASITES NIL) */
