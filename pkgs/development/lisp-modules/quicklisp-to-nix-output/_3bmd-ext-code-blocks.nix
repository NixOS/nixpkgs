args @ { fetchurl, ... }:
rec {
  baseName = ''_3bmd-ext-code-blocks'';
  version = ''3bmd-20200925-git'';

  description = ''extension to 3bmd implementing github style ``` delimited code blocks, with support for syntax highlighting using colorize, pygments, or chroma'';

  deps = [ args."_3bmd" args."alexandria" args."colorize" args."esrap" args."html-encode" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2020-09-25/3bmd-20200925-git.tgz'';
    sha256 = ''0sk4b0xma4vv6ssiskbz7h5bw8v8glm34mbv3llqywb50b9ks4fw'';
  };

  packageName = "3bmd-ext-code-blocks";

  asdFilesToKeep = ["3bmd-ext-code-blocks.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd-ext-code-blocks DESCRIPTION
    extension to 3bmd implementing github style ``` delimited code blocks, with support for syntax highlighting using colorize, pygments, or chroma
    SHA256 0sk4b0xma4vv6ssiskbz7h5bw8v8glm34mbv3llqywb50b9ks4fw URL
    http://beta.quicklisp.org/archive/3bmd/2020-09-25/3bmd-20200925-git.tgz MD5
    3b2c0b2094e473234742d150ac84abdd NAME 3bmd-ext-code-blocks FILENAME
    _3bmd-ext-code-blocks DEPS
    ((NAME 3bmd FILENAME _3bmd) (NAME alexandria FILENAME alexandria)
     (NAME colorize FILENAME colorize) (NAME esrap FILENAME esrap)
     (NAME html-encode FILENAME html-encode)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (3bmd alexandria colorize esrap html-encode split-sequence)
    VERSION 3bmd-20200925-git SIBLINGS
    (3bmd-ext-definition-lists 3bmd-ext-math 3bmd-ext-tables
     3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube 3bmd)
    PARASITES NIL) */
