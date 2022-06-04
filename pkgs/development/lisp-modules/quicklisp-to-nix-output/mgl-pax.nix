/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mgl-pax";
  version = "20220220-git";

  parasites = [ "mgl-pax/navigate" ];

  description = "Exploratory programming tool and documentation
  generator.";

  deps = [ args."alexandria" args."mgl-pax_dot_asdf" args."named-readtables" args."pythonic-string-reader" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mgl-pax/2022-02-20/mgl-pax-20220220-git.tgz";
    sha256 = "0wfdj8np8fflp51zqsby0fwhad675xk0nbw02w0xxp4sjya0hk5a";
  };

  packageName = "mgl-pax";

  asdFilesToKeep = ["mgl-pax.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax DESCRIPTION Exploratory programming tool and documentation
  generator.
    SHA256 0wfdj8np8fflp51zqsby0fwhad675xk0nbw02w0xxp4sjya0hk5a URL
    http://beta.quicklisp.org/archive/mgl-pax/2022-02-20/mgl-pax-20220220-git.tgz
    MD5 51050b8c146333bd352e77d9ffee5475 NAME mgl-pax FILENAME mgl-pax DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME mgl-pax.asdf FILENAME mgl-pax_dot_asdf)
     (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME swank FILENAME swank))
    DEPENDENCIES
    (alexandria mgl-pax.asdf named-readtables pythonic-string-reader swank)
    VERSION 20220220-git SIBLINGS (mgl-pax.asdf) PARASITES (mgl-pax/navigate)) */
