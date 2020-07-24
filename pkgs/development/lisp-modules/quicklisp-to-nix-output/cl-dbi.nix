args @ { fetchurl, ... }:
rec {
  baseName = ''cl-dbi'';
  version = ''20191007-git'';

  description = ''System lacks description'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."closer-mop" args."dbi" args."named-readtables" args."split-sequence" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2019-10-07/cl-dbi-20191007-git.tgz'';
    sha256 = ''0xsg0xqq88wsx6wf8nllfd0mk356bw2qw3c5c31rfj41wz5vpx35'';
  };

  packageName = "cl-dbi";

  asdFilesToKeep = ["cl-dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-dbi DESCRIPTION System lacks description SHA256
    0xsg0xqq88wsx6wf8nllfd0mk356bw2qw3c5c31rfj41wz5vpx35 URL
    http://beta.quicklisp.org/archive/cl-dbi/2019-10-07/cl-dbi-20191007-git.tgz
    MD5 bf524c4000468d12627fa419ae412abb NAME cl-dbi FILENAME cl-dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME named-readtables FILENAME named-readtables)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-annot cl-syntax cl-syntax-annot closer-mop
     dbi named-readtables split-sequence trivial-types)
    VERSION 20191007-git SIBLINGS
    (dbd-mysql dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
