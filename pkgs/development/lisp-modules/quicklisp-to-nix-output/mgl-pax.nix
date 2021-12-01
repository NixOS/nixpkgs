/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mgl-pax";
  version = "20211020-git";

  parasites = [ "mgl-pax/full" ];

  description = "Exploratory programming tool and documentation
  generator.";

  deps = [ args."_3bmd" args."_3bmd-ext-code-blocks" args."alexandria" args."babel" args."cl-fad" args."colorize" args."ironclad" args."named-readtables" args."pythonic-string-reader" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mgl-pax/2021-10-20/mgl-pax-20211020-git.tgz";
    sha256 = "04vddyvyxja8dabksfqqr80xjnvdiiv61zidjvijlpkk8shwaw1g";
  };

  packageName = "mgl-pax";

  asdFilesToKeep = ["mgl-pax.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax DESCRIPTION Exploratory programming tool and documentation
  generator.
    SHA256 04vddyvyxja8dabksfqqr80xjnvdiiv61zidjvijlpkk8shwaw1g URL
    http://beta.quicklisp.org/archive/mgl-pax/2021-10-20/mgl-pax-20211020-git.tgz
    MD5 2ad25d62d83b98e3e855b35414a5093d NAME mgl-pax FILENAME mgl-pax DEPS
    ((NAME 3bmd FILENAME _3bmd)
     (NAME 3bmd-ext-code-blocks FILENAME _3bmd-ext-code-blocks)
     (NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-fad FILENAME cl-fad) (NAME colorize FILENAME colorize)
     (NAME ironclad FILENAME ironclad)
     (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME swank FILENAME swank))
    DEPENDENCIES
    (3bmd 3bmd-ext-code-blocks alexandria babel cl-fad colorize ironclad
     named-readtables pythonic-string-reader swank)
    VERSION 20211020-git SIBLINGS NIL PARASITES (mgl-pax/full)) */
