args @ { fetchurl, ... }:
rec {
  baseName = ''ixf'';
  version = ''cl-20180228-git'';

  description = ''Tools to handle IBM PC version of IXF file format'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cl-fad" args."cl-ppcre" args."ieee-floats" args."local-time" args."md5" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ixf/2018-02-28/cl-ixf-20180228-git.tgz'';
    sha256 = ''1yqlzyl51kj5fjfg064fc9606zha5b2xdjapfivr2vqz4azs1nvs'';
  };

  packageName = "ixf";

  asdFilesToKeep = ["ixf.asd"];
  overrides = x: x;
}
/* (SYSTEM ixf DESCRIPTION Tools to handle IBM PC version of IXF file format
    SHA256 1yqlzyl51kj5fjfg064fc9606zha5b2xdjapfivr2vqz4azs1nvs URL
    http://beta.quicklisp.org/archive/cl-ixf/2018-02-28/cl-ixf-20180228-git.tgz
    MD5 23732795aa317d24c1a40cc321a0e394 NAME ixf FILENAME ixf DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME ieee-floats FILENAME ieee-floats)
     (NAME local-time FILENAME local-time) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cl-fad cl-ppcre ieee-floats local-time
     md5 split-sequence trivial-features)
    VERSION cl-20180228-git SIBLINGS NIL PARASITES NIL) */
