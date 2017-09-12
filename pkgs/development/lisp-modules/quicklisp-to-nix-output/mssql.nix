args @ { fetchurl, ... }:
rec {
  baseName = ''mssql'';
  version = ''cl-20170630-git'';

  description = '''';

  deps = [ args."cffi" args."garbage-pools" args."iterate" args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mssql/2017-06-30/cl-mssql-20170630-git.tgz'';
    sha256 = ''0vwssk39m8pqn8srwvbcnq43wkqlav5rvq64byrnpsrwlfcbfvxy'';
  };

  packageName = "mssql";

  asdFilesToKeep = ["mssql.asd"];
  overrides = x: x;
}
/* (SYSTEM mssql DESCRIPTION NIL SHA256
    0vwssk39m8pqn8srwvbcnq43wkqlav5rvq64byrnpsrwlfcbfvxy URL
    http://beta.quicklisp.org/archive/cl-mssql/2017-06-30/cl-mssql-20170630-git.tgz
    MD5 88e65c72923896df603ecf20039ae305 NAME mssql FILENAME mssql DEPS
    ((NAME cffi FILENAME cffi) (NAME garbage-pools FILENAME garbage-pools)
     (NAME iterate FILENAME iterate) (NAME parse-number FILENAME parse-number))
    DEPENDENCIES (cffi garbage-pools iterate parse-number) VERSION
    cl-20170630-git SIBLINGS NIL PARASITES NIL) */
