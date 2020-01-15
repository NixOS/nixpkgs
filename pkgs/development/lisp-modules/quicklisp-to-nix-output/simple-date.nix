args @ { fetchurl, ... }:
{
  baseName = ''simple-date'';
  version = ''postmodern-20190521-git'';

  parasites = [ "simple-date/postgres-glue" "simple-date/tests" ];

  description = '''';

  deps = [ args."cl-postgres" args."fiveam" args."md5" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2019-05-21/postmodern-20190521-git.tgz'';
    sha256 = ''1vphrizbhbs3r5rq4b8dh4149bz11h5xxilragwf4l2i619k3cp5'';
  };

  packageName = "simple-date";

  asdFilesToKeep = ["simple-date.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-date DESCRIPTION NIL SHA256
    1vphrizbhbs3r5rq4b8dh4149bz11h5xxilragwf4l2i619k3cp5 URL
    http://beta.quicklisp.org/archive/postmodern/2019-05-21/postmodern-20190521-git.tgz
    MD5 102567f386757cd52aca500c0c348d90 NAME simple-date FILENAME simple-date
    DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME fiveam FILENAME fiveam)
     (NAME md5 FILENAME md5) (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres fiveam md5 usocket) VERSION
    postmodern-20190521-git SIBLINGS (cl-postgres postmodern s-sql) PARASITES
    (simple-date/postgres-glue simple-date/tests)) */
