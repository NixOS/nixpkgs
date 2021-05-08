/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "_3bmd-ext-code-blocks";
  version = "3bmd-20201220-git";

  description = "extension to 3bmd implementing github style ``` delimited code blocks, with support for syntax highlighting using colorize, pygments, or chroma";

  deps = [ args."_3bmd" args."alexandria" args."colorize" args."esrap" args."html-encode" args."split-sequence" args."trivial-with-current-source-form" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/3bmd/2020-12-20/3bmd-20201220-git.tgz";
    sha256 = "0hcx8p8la3fmwhj8ddqik7bwrn9rvf5mcv6m77glimwckh51na71";
  };

  packageName = "3bmd-ext-code-blocks";

  asdFilesToKeep = ["3bmd-ext-code-blocks.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd-ext-code-blocks DESCRIPTION
    extension to 3bmd implementing github style ``` delimited code blocks, with support for syntax highlighting using colorize, pygments, or chroma
    SHA256 0hcx8p8la3fmwhj8ddqik7bwrn9rvf5mcv6m77glimwckh51na71 URL
    http://beta.quicklisp.org/archive/3bmd/2020-12-20/3bmd-20201220-git.tgz MD5
    67b6e5fa51d18817e7110e4fef6517ac NAME 3bmd-ext-code-blocks FILENAME
    _3bmd-ext-code-blocks DEPS
    ((NAME 3bmd FILENAME _3bmd) (NAME alexandria FILENAME alexandria)
     (NAME colorize FILENAME colorize) (NAME esrap FILENAME esrap)
     (NAME html-encode FILENAME html-encode)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-with-current-source-form FILENAME
      trivial-with-current-source-form))
    DEPENDENCIES
    (3bmd alexandria colorize esrap html-encode split-sequence
     trivial-with-current-source-form)
    VERSION 3bmd-20201220-git SIBLINGS
    (3bmd-ext-definition-lists 3bmd-ext-math 3bmd-ext-tables
     3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube 3bmd)
    PARASITES NIL) */
