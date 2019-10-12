args @ { fetchurl, ... }:
{
  baseName = ''ironclad'';
  version = ''v0.46'';

  parasites = [ "ironclad/tests" ];

  description = ''A cryptographic toolkit written in pure Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."nibbles" args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ironclad/2019-07-10/ironclad-v0.46.tgz'';
    sha256 = ''1bcqz7z30dpr9rz5wg94bbq93swn6lxqj60rn9f5q0fryn9na3l2'';
  };

  packageName = "ironclad";

  asdFilesToKeep = ["ironclad.asd"];
  overrides = x: x;
}
/* (SYSTEM ironclad DESCRIPTION
    A cryptographic toolkit written in pure Common Lisp SHA256
    1bcqz7z30dpr9rz5wg94bbq93swn6lxqj60rn9f5q0fryn9na3l2 URL
    http://beta.quicklisp.org/archive/ironclad/2019-07-10/ironclad-v0.46.tgz
    MD5 23f67c2312723bdaf1ff78898d2354c7 NAME ironclad FILENAME ironclad DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME nibbles FILENAME nibbles) (NAME rt FILENAME rt))
    DEPENDENCIES (alexandria bordeaux-threads nibbles rt) VERSION v0.46
    SIBLINGS (ironclad-text) PARASITES (ironclad/tests)) */
