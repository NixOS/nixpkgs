args @ { fetchurl, ... }:
rec {
  baseName = ''kmrcl'';
  version = ''20150923-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/kmrcl/2015-09-23/kmrcl-20150923-git.tgz'';
    sha256 = ''0sx7p16pp5i4qr569p2265ky6rd65gyjp21k348a6c3fs2yn0r2g'';
  };

  packageName = "kmrcl";

  asdFilesToKeep = ["kmrcl.asd"];
  overrides = x: x;
}
/* (SYSTEM kmrcl DESCRIPTION NIL SHA256
    0sx7p16pp5i4qr569p2265ky6rd65gyjp21k348a6c3fs2yn0r2g URL
    http://beta.quicklisp.org/archive/kmrcl/2015-09-23/kmrcl-20150923-git.tgz
    MD5 0cd15d3ed3e7d56528dd3243d1a5c9b1 NAME kmrcl FILENAME kmrcl DEPS NIL
    DEPENDENCIES NIL VERSION 20150923-git SIBLINGS (kmrcl-tests) PARASITES NIL) */
