args @ { fetchurl, ... }:
{
  baseName = ''abnf'';
  version = ''cl-20150608-git'';

  description = ''ABNF Parser Generator, per RFC2234'';

  deps = [ args."alexandria" args."cl-ppcre" args."esrap" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz'';
    sha256 = ''00x95h7v5q7azvr9wrpcfcwsq3sdipjr1hgq9a9lbimp8gfbz687'';
  };

  packageName = "abnf";

  asdFilesToKeep = ["abnf.asd"];
  overrides = x: x;
}
/* (SYSTEM abnf DESCRIPTION ABNF Parser Generator, per RFC2234 SHA256
    00x95h7v5q7azvr9wrpcfcwsq3sdipjr1hgq9a9lbimp8gfbz687 URL
    http://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz
    MD5 311c2b17e49666dac1c2bb45256be708 NAME abnf FILENAME abnf DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME esrap FILENAME esrap))
    DEPENDENCIES (alexandria cl-ppcre esrap) VERSION cl-20150608-git SIBLINGS
    NIL PARASITES NIL) */
