args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20171227-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ args."alexandria" args."babel" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-12-27/babel-20171227-git.tgz'';
    sha256 = ''166y6j9ma1vxzy5bcwnbi37zwgn2zssx5x1q7zr63kyj2caiw2rf'';
  };

  packageName = "babel-streams";

  asdFilesToKeep = ["babel-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM babel-streams DESCRIPTION
    Some useful streams based on Babel's encoding code SHA256
    166y6j9ma1vxzy5bcwnbi37zwgn2zssx5x1q7zr63kyj2caiw2rf URL
    http://beta.quicklisp.org/archive/babel/2017-12-27/babel-20171227-git.tgz
    MD5 8ea39f73873847907a8bb67f99f16ecd NAME babel-streams FILENAME
    babel-streams DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria babel trivial-features trivial-gray-streams)
    VERSION babel-20171227-git SIBLINGS (babel-tests babel) PARASITES NIL) */
