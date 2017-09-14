args @ { fetchurl, ... }:
rec {
  baseName = ''ixf'';
  version = ''cl-20170630-git'';

  description = ''Tools to handle IBM PC version of IXF file format'';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."ieee-floats" args."local-time" args."md5" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ixf/2017-06-30/cl-ixf-20170630-git.tgz'';
    sha256 = ''1qfmsz3lbydas7iv0bxdl4gl5ah4ydjxxqfpyini7qy0cb4wplf2'';
  };

  packageName = "ixf";

  asdFilesToKeep = ["ixf.asd"];
  overrides = x: x;
}
/* (SYSTEM ixf DESCRIPTION Tools to handle IBM PC version of IXF file format
    SHA256 1qfmsz3lbydas7iv0bxdl4gl5ah4ydjxxqfpyini7qy0cb4wplf2 URL
    http://beta.quicklisp.org/archive/cl-ixf/2017-06-30/cl-ixf-20170630-git.tgz
    MD5 51db2caba094cac90982396cf552c847 NAME ixf FILENAME ixf DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME ieee-floats FILENAME ieee-floats)
     (NAME local-time FILENAME local-time) (NAME md5 FILENAME md5)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES
    (alexandria babel cl-ppcre ieee-floats local-time md5 split-sequence)
    VERSION cl-20170630-git SIBLINGS NIL PARASITES NIL) */
