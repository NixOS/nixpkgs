args @ { fetchurl, ... }:
rec {
  baseName = ''cl-store'';
  version = ''20160531-git'';

  parasites = [ "cl-store-tests" ];

  description = ''Serialization package'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-store/2016-05-31/cl-store-20160531-git.tgz'';
    sha256 = ''0j1pfgvzy6l7hb68xsz2dghsa94lip7caq6f6608jsqadmdswljz'';
  };

  packageName = "cl-store";

  asdFilesToKeep = ["cl-store.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-store DESCRIPTION Serialization package SHA256
    0j1pfgvzy6l7hb68xsz2dghsa94lip7caq6f6608jsqadmdswljz URL
    http://beta.quicklisp.org/archive/cl-store/2016-05-31/cl-store-20160531-git.tgz
    MD5 8b3f33956b05d8e900346663f6abca3c NAME cl-store FILENAME cl-store DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20160531-git SIBLINGS NIL
    PARASITES (cl-store-tests)) */
