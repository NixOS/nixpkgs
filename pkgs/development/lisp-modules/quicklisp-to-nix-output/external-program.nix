args @ { fetchurl, ... }:
rec {
  baseName = ''external-program'';
  version = ''20160825-git'';

  parasites = [ "external-program-test" ];

  description = '''';

  deps = [ args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/external-program/2016-08-25/external-program-20160825-git.tgz'';
    sha256 = ''0avnnhxxa1wfri9i3m1339nszyp1w2cilycc948nf5awz4mckq13'';
  };

  packageName = "external-program";

  asdFilesToKeep = ["external-program.asd"];
  overrides = x: x;
}
/* (SYSTEM external-program DESCRIPTION NIL SHA256
    0avnnhxxa1wfri9i3m1339nszyp1w2cilycc948nf5awz4mckq13 URL
    http://beta.quicklisp.org/archive/external-program/2016-08-25/external-program-20160825-git.tgz
    MD5 6902724c4f762a17645c46b0a1d8efde NAME external-program FILENAME
    external-program DEPS
    ((NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (fiveam trivial-features) VERSION 20160825-git SIBLINGS NIL
    PARASITES (external-program-test)) */
