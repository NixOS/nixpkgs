args @ { fetchurl, ... }:
rec {
  baseName = ''closure-common'';
  version = ''20101107-git'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closure-common/2010-11-07/closure-common-20101107-git.tgz'';
    sha256 = ''1982dpn2z7rlznn74gxy9biqybh2d4r1n688h9pn1s2bssgv3hk4'';
  };

  packageName = "closure-common";

  asdFilesToKeep = ["closure-common.asd"];
  overrides = x: x;
}
/* (SYSTEM closure-common DESCRIPTION NIL SHA256
    1982dpn2z7rlznn74gxy9biqybh2d4r1n688h9pn1s2bssgv3hk4 URL
    http://beta.quicklisp.org/archive/closure-common/2010-11-07/closure-common-20101107-git.tgz
    MD5 12c45a2f0420b2e86fa06cb6575b150a NAME closure-common FILENAME
    closure-common DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria babel trivial-features trivial-gray-streams)
    VERSION 20101107-git SIBLINGS NIL PARASITES NIL) */
