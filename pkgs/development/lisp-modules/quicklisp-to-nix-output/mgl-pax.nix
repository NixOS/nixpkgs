/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mgl-pax";
  version = "20210411-git";

  parasites = [ "mgl-pax/test" ];

  description = "Exploratory programming tool and documentation
  generator.";

  deps = [ args."_3bmd" args."_3bmd-ext-code-blocks" args."alexandria" args."babel" args."bordeaux-threads" args."cl-fad" args."colorize" args."esrap" args."html-encode" args."ironclad" args."named-readtables" args."pythonic-string-reader" args."split-sequence" args."swank" args."trivial-features" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mgl-pax/2021-04-11/mgl-pax-20210411-git.tgz";
    sha256 = "0dq5jkb6li0s1gqj6hfhifs6cd4kypavv2kjqg5zgs6zfs82sxh3";
  };

  packageName = "mgl-pax";

  asdFilesToKeep = ["mgl-pax.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax DESCRIPTION Exploratory programming tool and documentation
  generator.
    SHA256 0dq5jkb6li0s1gqj6hfhifs6cd4kypavv2kjqg5zgs6zfs82sxh3 URL
    http://beta.quicklisp.org/archive/mgl-pax/2021-04-11/mgl-pax-20210411-git.tgz
    MD5 44cf1bd71e6c40c256a43a87efa2c2a1 NAME mgl-pax FILENAME mgl-pax DEPS
    ((NAME 3bmd FILENAME _3bmd)
     (NAME 3bmd-ext-code-blocks FILENAME _3bmd-ext-code-blocks)
     (NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME colorize FILENAME colorize)
     (NAME esrap FILENAME esrap) (NAME html-encode FILENAME html-encode)
     (NAME ironclad FILENAME ironclad)
     (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME split-sequence FILENAME split-sequence) (NAME swank FILENAME swank)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (3bmd 3bmd-ext-code-blocks alexandria babel bordeaux-threads cl-fad
     colorize esrap html-encode ironclad named-readtables
     pythonic-string-reader split-sequence swank trivial-features
     trivial-with-current-source-form)
    VERSION 20210411-git SIBLINGS NIL PARASITES (mgl-pax/test)) */
