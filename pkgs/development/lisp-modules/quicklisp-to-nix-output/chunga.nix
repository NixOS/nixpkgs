args @ { fetchurl, ... }:
rec {
  baseName = ''chunga'';
  version = ''20180131-git'';

  description = ''System lacks description'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chunga/2018-01-31/chunga-20180131-git.tgz'';
    sha256 = ''0crlv6n6al7j9b40dpfjd13870ih5hzwra29xxfg3zg2zy2kdnrq'';
  };

  packageName = "chunga";

  asdFilesToKeep = ["chunga.asd"];
  overrides = x: x;
}
/* (SYSTEM chunga DESCRIPTION System lacks description SHA256
    0crlv6n6al7j9b40dpfjd13870ih5hzwra29xxfg3zg2zy2kdnrq URL
    http://beta.quicklisp.org/archive/chunga/2018-01-31/chunga-20180131-git.tgz
    MD5 044b684535b11b1eee1cf939bec6e14a NAME chunga FILENAME chunga DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20180131-git SIBLINGS NIL PARASITES NIL) */
