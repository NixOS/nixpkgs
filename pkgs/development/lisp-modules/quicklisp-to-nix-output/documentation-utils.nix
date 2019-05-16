args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20180831-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2018-08-31/documentation-utils-20180831-git.tgz'';
    sha256 = ''0g26hgppynrfdkpaplb77xzrsmsdzmlnqgl8336l08zmg80x90n5'';
  };

  packageName = "documentation-utils";

  asdFilesToKeep = ["documentation-utils.asd"];
  overrides = x: x;
}
/* (SYSTEM documentation-utils DESCRIPTION
    A few simple tools to help you with documenting your library. SHA256
    0g26hgppynrfdkpaplb77xzrsmsdzmlnqgl8336l08zmg80x90n5 URL
    http://beta.quicklisp.org/archive/documentation-utils/2018-08-31/documentation-utils-20180831-git.tgz
    MD5 e0f58ffe20602cada3413b4eeec909ef NAME documentation-utils FILENAME
    documentation-utils DEPS ((NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (trivial-indent) VERSION 20180831-git SIBLINGS
    (multilang-documentation-utils) PARASITES NIL) */
