/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "_3bmd";
  version = "20210411-git";

  description = "markdown processor in CL using esrap parser.";

  deps = [ args."alexandria" args."esrap" args."split-sequence" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/3bmd/2021-04-11/3bmd-20210411-git.tgz";
    sha256 = "1gwl3r8cffr8yldi0x7zdzbmngqhli2d19wsky5cf8h80m30k4vp";
  };

  packageName = "3bmd";

  asdFilesToKeep = ["3bmd.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256
    1gwl3r8cffr8yldi0x7zdzbmngqhli2d19wsky5cf8h80m30k4vp URL
    http://beta.quicklisp.org/archive/3bmd/2021-04-11/3bmd-20210411-git.tgz MD5
    09f9290aa1708aeb469fb5154ab1a397 NAME 3bmd FILENAME _3bmd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (alexandria esrap split-sequence trivial-with-current-source-form) VERSION
    20210411-git SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-math
     3bmd-ext-tables 3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)
    PARASITES NIL) */
