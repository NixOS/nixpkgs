args @ { fetchurl, ... }:
rec {
  baseName = ''utilities_dot_print-items'';
  version = ''20190813-git'';

  parasites = [ "utilities.print-items/test" ];

  description = ''A protocol for flexible and composable printing.'';

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/utilities.print-items/2019-08-13/utilities.print-items-20190813-git.tgz'';
    sha256 = ''12l4kzz621qfcg8p5qzyxp4n4hh9wdlpiziykwb4c80g32rdwkc2'';
  };

  packageName = "utilities.print-items";

  asdFilesToKeep = ["utilities.print-items.asd"];
  overrides = x: x;
}
/* (SYSTEM utilities.print-items DESCRIPTION
    A protocol for flexible and composable printing. SHA256
    12l4kzz621qfcg8p5qzyxp4n4hh9wdlpiziykwb4c80g32rdwkc2 URL
    http://beta.quicklisp.org/archive/utilities.print-items/2019-08-13/utilities.print-items-20190813-git.tgz
    MD5 0f26580bb5d3587ed1815f70976b2a0a NAME utilities.print-items FILENAME
    utilities_dot_print-items DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20190813-git SIBLINGS NIL
    PARASITES (utilities.print-items/test)) */
