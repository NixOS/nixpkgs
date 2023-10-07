/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-interpol";
  version = "20201220-git";

  parasites = [ "cl-interpol-test" ];

  description = "System lacks description";

  deps = [ args."cl-ppcre" args."cl-unicode" args."flexi-streams" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-interpol/2020-12-20/cl-interpol-20201220-git.tgz";
    sha256 = "1q3zxsbl5br08lv481jsqmq8r9yayp44x6icixcxx5sdz6fbcd3d";
  };

  packageName = "cl-interpol";

  asdFilesToKeep = ["cl-interpol.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-interpol DESCRIPTION System lacks description SHA256
    1q3zxsbl5br08lv481jsqmq8r9yayp44x6icixcxx5sdz6fbcd3d URL
    http://beta.quicklisp.org/archive/cl-interpol/2020-12-20/cl-interpol-20201220-git.tgz
    MD5 d678c521474e1774185b78883396da49 NAME cl-interpol FILENAME cl-interpol
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (cl-ppcre cl-unicode flexi-streams named-readtables) VERSION
    20201220-git SIBLINGS NIL PARASITES (cl-interpol-test)) */
