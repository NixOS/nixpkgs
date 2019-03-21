args @ { fetchurl, ... }:
rec {
  baseName = ''simple-date'';
  version = ''postmodern-20190107-git'';

  parasites = [ "simple-date/postgres-glue" "simple-date/tests" ];

  description = '''';

  deps = [ args."cl-postgres" args."fiveam" args."md5" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-01-07/postmodern-20190107-git.tgz'';
    sha256 = ''030p5kp593p4z7p3k0828dlayglw2si3q187z1fafgpvspp42sd5'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION NIL SHA256
    030p5kp593p4z7p3k0828dlayglw2si3q187z1fafgpvspp42sd5 URL
    http://beta.quicklisp.org/archive/postmodern/2019-01-07/postmodern-20190107-git.tgz
    MD5 3f6f78c4fb0f5a8bb9f13247f1f3d6eb NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres fiveam md5 usocket) VERSION
    postmodern-20190107-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/postgres-glue simple-date/tests)) */
