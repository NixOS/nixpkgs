args @ { fetchurl, ... }:
{
  baseName = ''mssql'';
  version = ''cl-20180228-git'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."cffi" args."garbage-pools" args."iterate" args."parse-number" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mssql/2018-02-28/cl-mssql-20180228-git.tgz'';
    sha256 = ''1f9vq78xx4vv1898cigkf09mzimknc6ry6qrkys3xj167vyqhwm0'';
  };

  packageName = "mssql";

  asdFilesToKeep = ["mssql.asd"];
  overrides = x: x;
}
/* (SYSTEM mssql DESCRIPTION NIL SHA256
    1f9vq78xx4vv1898cigkf09mzimknc6ry6qrkys3xj167vyqhwm0 URL
    http://beta.quicklisp.org/archive/cl-mssql/2018-02-28/cl-mssql-20180228-git.tgz
    MD5 03a269f5221948393643432fc6de9d5d NAME mssql FILENAME mssql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME garbage-pools FILENAME garbage-pools)
     (NAME iterate FILENAME iterate) (NAME parse-number FILENAME parse-number)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi garbage-pools iterate parse-number trivial-features)
    VERSION cl-20180228-git SIBLINGS NIL PARASITES NIL) */
