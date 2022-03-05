/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mgl-pax";
  version = "20211209-git";

  parasites = [ "mgl-pax/document" "mgl-pax/navigate" ];

  description = "Exploratory programming tool and documentation
  generator.";

  deps = [ args."_3bmd" args."_3bmd-ext-code-blocks" args."alexandria" args."colorize" args."md5" args."named-readtables" args."pythonic-string-reader" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mgl-pax/2021-12-09/mgl-pax-20211209-git.tgz";
    sha256 = "19d47msc8240bldkc0fi60cpzsx1q9392dxhmqn28gn7998pdkgh";
  };

  packageName = "mgl-pax";

  asdFilesToKeep = ["mgl-pax.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax DESCRIPTION Exploratory programming tool and documentation
  generator.
    SHA256 19d47msc8240bldkc0fi60cpzsx1q9392dxhmqn28gn7998pdkgh URL
    http://beta.quicklisp.org/archive/mgl-pax/2021-12-09/mgl-pax-20211209-git.tgz
    MD5 605583bb2910e0fe2211c8152fe38e0e NAME mgl-pax FILENAME mgl-pax DEPS
    ((NAME 3bmd FILENAME _3bmd)
     (NAME 3bmd-ext-code-blocks FILENAME _3bmd-ext-code-blocks)
     (NAME alexandria FILENAME alexandria) (NAME colorize FILENAME colorize)
     (NAME md5 FILENAME md5) (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME swank FILENAME swank))
    DEPENDENCIES
    (3bmd 3bmd-ext-code-blocks alexandria colorize md5 named-readtables
     pythonic-string-reader swank)
    VERSION 20211209-git SIBLINGS NIL PARASITES
    (mgl-pax/document mgl-pax/navigate)) */
