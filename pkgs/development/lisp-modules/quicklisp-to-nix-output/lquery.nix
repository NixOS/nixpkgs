/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lquery";
  version = "20201220-git";

  description = "A library to allow jQuery-like HTML/DOM manipulation.";

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lquery/2020-12-20/lquery-20201220-git.tgz";
    sha256 = "0mfnk1p73aihraklw802j5mjgc8cjxva0mdf0c4p7b253crf15jx";
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    0mfnk1p73aihraklw802j5mjgc8cjxva0mdf0c4p7b253crf15jx URL
    http://beta.quicklisp.org/archive/lquery/2020-12-20/lquery-20201220-git.tgz
    MD5 a71685848959cf33cd6963b4a5f9e2ed NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20201220-git SIBLINGS (lquery-test) PARASITES NIL) */
