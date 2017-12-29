args @ { fetchurl, ... }:
rec {
  baseName = ''swank'';
  version = ''slime-v2.19'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/slime/2017-02-27/slime-v2.19.tgz'';
    sha256 = ''1w3xq4kiy06wbmk2sf30saqgy1qa9v2llbi6bqy7hrm956yh6dza'';
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION NIL SHA256
    1w3xq4kiy06wbmk2sf30saqgy1qa9v2llbi6bqy7hrm956yh6dza URL
    http://beta.quicklisp.org/archive/slime/2017-02-27/slime-v2.19.tgz MD5
    7e1540ebb970db0f77b6e6cabb36ba41 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.19 SIBLINGS NIL PARASITES NIL) */
