/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "utilities_dot_print-items";
  version = "20210411-git";

  parasites = [ "utilities.print-items/test" ];

  description = "A protocol for flexible and composable printing.";

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/utilities.print-items/2021-04-11/utilities.print-items-20210411-git.tgz";
    sha256 = "0da2m4b993w31wph2ybdmdd6rycadrp44ccjdba5pygpkf3x00gx";
  };

  packageName = "utilities.print-items";

  asdFilesToKeep = ["utilities.print-items.asd"];
  overrides = x: x;
}
/* (SYSTEM utilities.print-items DESCRIPTION
    A protocol for flexible and composable printing. SHA256
    0da2m4b993w31wph2ybdmdd6rycadrp44ccjdba5pygpkf3x00gx URL
    http://beta.quicklisp.org/archive/utilities.print-items/2021-04-11/utilities.print-items-20210411-git.tgz
    MD5 35be0e5ee4c957699082fb6ae8f14ef2 NAME utilities.print-items FILENAME
    utilities_dot_print-items DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION 20210411-git SIBLINGS NIL
    PARASITES (utilities.print-items/test)) */
