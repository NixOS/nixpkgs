args @ { fetchurl, ... }:
rec {
  baseName = ''garbage-pools'';
  version = ''20130720-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz'';
    sha256 = ''1idnba1pxayn0k5yzqp9lswg7ywjhavi59lrdnphfqajjpyi9w05'';
  };

  packageName = "garbage-pools";

  asdFilesToKeep = ["garbage-pools.asd"];
  overrides = x: x;
}
/* (SYSTEM garbage-pools DESCRIPTION NIL SHA256
    1idnba1pxayn0k5yzqp9lswg7ywjhavi59lrdnphfqajjpyi9w05 URL
    http://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz
    MD5 f691e2ddf6ba22b3451c24b61d4ee8b6 NAME garbage-pools FILENAME
    garbage-pools DEPS NIL DEPENDENCIES NIL VERSION 20130720-git SIBLINGS
    (garbage-pools-test) PARASITES NIL) */
