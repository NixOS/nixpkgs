/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-semver";
  version = "20201220-git";

  description = "Semantic Version implementation";

  deps = [ args."alexandria" args."esrap" args."named-readtables" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-semver/2020-12-20/cl-semver-20201220-git.tgz";
    sha256 = "02m23kwsz49dh7jq2rgcd1c4asgjj1g7dy321hyr07k5hqmhk92y";
  };

  packageName = "cl-semver";

  asdFilesToKeep = ["cl-semver.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-semver DESCRIPTION Semantic Version implementation SHA256
    02m23kwsz49dh7jq2rgcd1c4asgjj1g7dy321hyr07k5hqmhk92y URL
    http://beta.quicklisp.org/archive/cl-semver/2020-12-20/cl-semver-20201220-git.tgz
    MD5 7fcc6938d4618687bf1e18ba40d6ac6e NAME cl-semver FILENAME cl-semver DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria esrap named-readtables trivial-with-current-source-form)
    VERSION 20201220-git SIBLINGS (cl-semver-test) PARASITES NIL) */
