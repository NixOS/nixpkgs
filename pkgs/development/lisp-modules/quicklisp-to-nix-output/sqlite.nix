args @ { fetchurl, ... }:
rec {
  baseName = ''sqlite'';
  version = ''cl-20130615-git'';

  description = ''System lacks description'';

  deps = [ args."alexandria" args."babel" args."cffi" args."iterate" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz'';
    sha256 = ''0db1fvvnsrnxmp272ycnl2kwhymjwrimr8z4djvjlg6cvjxk6lqh'';
  };

  packageName = "sqlite";

  asdFilesToKeep = ["sqlite.asd"];
  overrides = x: x;
}
/* (SYSTEM sqlite DESCRIPTION System lacks description SHA256
    0db1fvvnsrnxmp272ycnl2kwhymjwrimr8z4djvjlg6cvjxk6lqh URL
    http://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz
    MD5 93be7c68f587d830941be55f2c2f1c8b NAME sqlite FILENAME sqlite DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi iterate trivial-features) VERSION
    cl-20130615-git SIBLINGS NIL PARASITES NIL) */
