/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "utilities_dot_print-tree";
  version = "20200325-git";

  parasites = [ "utilities.print-tree/test" ];

  description = "This system provides simple facilities for printing tree structures.";

  deps = [ args."alexandria" args."fiveam" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/utilities.print-tree/2020-03-25/utilities.print-tree-20200325-git.tgz";
    sha256 = "1nam8g2ppzkzpkwwhmil9y68is43ljpvc7hd64zxp4zsaqab5dww";
  };

  packageName = "utilities.print-tree";

  asdFilesToKeep = ["utilities.print-tree.asd"];
  overrides = x: x;
}
/* (SYSTEM utilities.print-tree DESCRIPTION
    This system provides simple facilities for printing tree structures. SHA256
    1nam8g2ppzkzpkwwhmil9y68is43ljpvc7hd64zxp4zsaqab5dww URL
    http://beta.quicklisp.org/archive/utilities.print-tree/2020-03-25/utilities.print-tree-20200325-git.tgz
    MD5 618bf5b42c415a44a1566f4f96a2c69a NAME utilities.print-tree FILENAME
    utilities_dot_print-tree DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria fiveam uiop) VERSION 20200325-git SIBLINGS NIL
    PARASITES (utilities.print-tree/test)) */
