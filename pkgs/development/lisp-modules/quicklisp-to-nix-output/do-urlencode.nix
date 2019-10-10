args @ { fetchurl, ... }:
rec {
  baseName = ''do-urlencode'';
  version = ''20181018-git'';

  description = ''Percent Encoding (aka URL Encoding) library'';

  deps = [ args."alexandria" args."babel" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/do-urlencode/2018-10-18/do-urlencode-20181018-git.tgz'';
    sha256 = ''1cajd219s515y65kp562c6xczqaq0p4lyp13iv00z6i44rijmfp2'';
  };

  packageName = "do-urlencode";

  asdFilesToKeep = ["do-urlencode.asd"];
  overrides = x: x;
}
/* (SYSTEM do-urlencode DESCRIPTION Percent Encoding (aka URL Encoding) library
    SHA256 1cajd219s515y65kp562c6xczqaq0p4lyp13iv00z6i44rijmfp2 URL
    http://beta.quicklisp.org/archive/do-urlencode/2018-10-18/do-urlencode-20181018-git.tgz
    MD5 cb6ab78689fe52680ee1b94cd7738b94 NAME do-urlencode FILENAME
    do-urlencode DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel trivial-features) VERSION 20181018-git
    SIBLINGS NIL PARASITES NIL) */
