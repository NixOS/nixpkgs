args @ { fetchurl, ... }:
rec {
  baseName = ''lift'';
  version = ''20151031-git'';

  description = ''LIsp Framework for Testing'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lift/2015-10-31/lift-20151031-git.tgz'';
    sha256 = ''1h8fkpm377brbrc06zdynd2qilc85vr9i8r9f8pjqqmk3p1qyl46'';
  };

  packageName = "lift";

  asdFilesToKeep = ["lift.asd"];
  overrides = x: x;
}
/* (SYSTEM lift DESCRIPTION LIsp Framework for Testing SHA256
    1h8fkpm377brbrc06zdynd2qilc85vr9i8r9f8pjqqmk3p1qyl46 URL
    http://beta.quicklisp.org/archive/lift/2015-10-31/lift-20151031-git.tgz MD5
    b92e97b3d337607743f47bde0889f3ee NAME lift FILENAME lift DEPS NIL
    DEPENDENCIES NIL VERSION 20151031-git SIBLINGS
    (lift-documentation lift-test) PARASITES NIL) */
