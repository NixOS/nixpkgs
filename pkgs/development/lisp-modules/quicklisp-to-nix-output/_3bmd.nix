/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "_3bmd";
  version = "20201220-git";

  description = "markdown processor in CL using esrap parser.";

  deps = [ args."alexandria" args."esrap" args."split-sequence" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/3bmd/2020-12-20/3bmd-20201220-git.tgz";
    sha256 = "0hcx8p8la3fmwhj8ddqik7bwrn9rvf5mcv6m77glimwckh51na71";
  };

  packageName = "3bmd";

  asdFilesToKeep = ["3bmd.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256
    0hcx8p8la3fmwhj8ddqik7bwrn9rvf5mcv6m77glimwckh51na71 URL
    http://beta.quicklisp.org/archive/3bmd/2020-12-20/3bmd-20201220-git.tgz MD5
    67b6e5fa51d18817e7110e4fef6517ac NAME 3bmd FILENAME _3bmd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria esrap split-sequence trivial-with-current-source-form) VERSION
    20201220-git SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-math
     3bmd-ext-tables 3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)
    PARASITES NIL) */
