args @ { fetchurl, ... }:
rec {
  baseName = ''s-sql'';
  version = ''postmodern-20180131-git'';

  description = '''';

  deps = [ args."cl-postgres" args."md5" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz'';
    sha256 = ''0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki'';
  };

  packageName = "s-sql";

  asdFilesToKeep = ["s-sql.asd"];
  overrides = x: x;
}
/* (SYSTEM s-sql DESCRIPTION NIL SHA256
    0mz5pm759py1iscfn44c00dal2fijkyp5479fpx9l6i7wrdx2mki URL
    http://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz
    MD5 a3b7bf25eb342cd49fe144fcd7ddcb16 NAME s-sql FILENAME s-sql DEPS
    ((NAME cl-postgres FILENAME cl-postgres) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (cl-postgres md5 split-sequence usocket) VERSION
    postmodern-20180131-git SIBLINGS (cl-postgres postmodern simple-date)
    PARASITES NIL) */
