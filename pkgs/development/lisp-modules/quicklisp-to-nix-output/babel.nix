args @ { fetchurl, ... }:
{
  baseName = ''babel'';
  version = ''20171227-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."alexandria" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-12-27/babel-20171227-git.tgz'';
    sha256 = ''166y6j9ma1vxzy5bcwnbi37zwgn2zssx5x1q7zr63kyj2caiw2rf'';
  };

  packageName = "babel";

  asdFilesToKeep = ["babel.asd"];
  overrides = x: x;
}
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256
    166y6j9ma1vxzy5bcwnbi37zwgn2zssx5x1q7zr63kyj2caiw2rf URL
    http://beta.quicklisp.org/archive/babel/2017-12-27/babel-20171227-git.tgz
    MD5 8ea39f73873847907a8bb67f99f16ecd NAME babel FILENAME babel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria trivial-features) VERSION 20171227-git SIBLINGS
    (babel-streams babel-tests) PARASITES NIL) */
