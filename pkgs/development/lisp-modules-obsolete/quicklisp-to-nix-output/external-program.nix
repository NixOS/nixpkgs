/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "external-program";
  version = "20190307-git";

  parasites = [ "external-program-test" ];

  description = "System lacks description";

  deps = [ args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/external-program/2019-03-07/external-program-20190307-git.tgz";
    sha256 = "1nl3mngh7vp2l9mfbdhni4nc164zznafnl74p1kv9j07n5fcpnyz";
  };

  packageName = "external-program";

  asdFilesToKeep = ["external-program.asd"];
  overrides = x: x;
}
/* (SYSTEM external-program DESCRIPTION System lacks description SHA256
    1nl3mngh7vp2l9mfbdhni4nc164zznafnl74p1kv9j07n5fcpnyz URL
    http://beta.quicklisp.org/archive/external-program/2019-03-07/external-program-20190307-git.tgz
    MD5 b30fe104c34059506fd4c493fa79fe1a NAME external-program FILENAME
    external-program DEPS
    ((NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (fiveam trivial-features) VERSION 20190307-git SIBLINGS NIL
    PARASITES (external-program-test)) */
